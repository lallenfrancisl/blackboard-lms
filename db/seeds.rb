# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

about_text = "Nestled amidst breathtaking landscapes, Grand Hotel stands as an epitome of luxury and refinement. Renowned for its exquisite continental cuisine and impeccable service, this iconic establishment offers an unparalleled dining experience that captivates the senses. Each dish is meticulously crafted to perfection, showcasing the culinary mastery of our esteemed chefs. From the elegant ambiance to the attentive staff, every detail at Grand Hotel is designed to elevate your stay to unforgettable heights. Whether indulging in a sumptuous meal in our fine dining restaurant or savoring a decadent dessert in the charming cafe, guests are treated to a feast for both the palate and the soul. Experience the epitome of culinary excellence and unparalleled service at Grand Hotel, where every moment is a celebration of sophistication and taste."

def create_user(name, role, team_name="My Team", partner=nil)
  ActiveRecord::Base.transaction do
    user = User.create!(
      name: name,
      role: role,
      email: "#{name.downcase}@example.com",
      password: "password",
      password_confirmation: "password",
      team_name: team_name,
      learning_partner: partner
    )

    user.confirm
  end
end

def create_partner(name, about, logo, banner)
  LearningPartner.create!(
      name: name,
      about: about,
      logo: File.open(Rails.root.join("db/data/#{logo}")),
      banner: File.open(Rails.root.join("db/data/#{banner}"))
    )
end

def create_course(name, description, banner)
  Course.create!(
    title: name,
    description: description,
    banner: File.open(Rails.root.join("db/data/#{banner}"))
  )
end

def create_module(name, description, course)
  m = CourseModule.new(
    title: name,
    description: description,
    course: course
  )
  CourseManagementService.instance.set_module_attributes(course, m)

  m.save!
end

def create_lesson(title, description, url, course_module)
  l = Lesson.new(title: title, description: description, video_url: url, duration: rand(1..10), course_module: course_module)
  CourseManagementService.instance.set_lesson_attributes(course_module, l)
  l.save!
end

def create_quiz(q, a, b, c, d, ans, course_module)
  q = Quiz.new(question: q, option_a: a, option_b: b, option_c: c, option_d: d, answer: ans, course_module: course_module)
  CourseManagementService.instance.set_quiz_attributes(course_module, q)
  q.save!
end

if Rails.env.development?

  admins = [%w[Deepak admin Superskills]]

  admins.each { |name, role, team_name| create_user(name, role, team_name) }

  other_users = [
    %w[Jubin owner],
    %w[Ajith manager],
    %w[Poornima learner]
  ]

  partners = [["The Grand Budapest Hotel",
               "Welcome to The Grand Budapest Hotel, a luxurious retreat nestled in the picturesque mountains of the Republic of Zubrowka. Our hotel combines old-world elegance with modern comfort, offering meticulously restored rooms and suites designed for utmost relaxation. Indulge in gourmet dining at our world-class restaurant and unwind with a handcrafted cocktail at our stylish café and bar. Rejuvenate at our luxurious spa, stay active in our fully equipped fitness center, or take a dip in our indoor swimming pool. Our elegant event spaces and expert planning team make us the perfect venue for weddings and conferences. Located near the charming town of Lutz, guests can explore historic sites and vibrant local culture. Surrounded by stunning natural landscapes, our hotel is ideal for outdoor activities like hiking and skiing. Steeped in rich history, The Grand Budapest Hotel offers a unique and enriching experience. Book your stay today and discover the magic and charm of our iconic establishment. Experience unparalleled service and timeless sophistication at The Grand Budapest Hotel.",
               "hotel_logo.jpg",
               "hotel_banner.jpg"]]

  partners.each { |name, about ,logo, banner| create_partner(name, about, logo, banner) }

  partner = LearningPartner.first

  other_users.each { |name, role| create_user(name, role, "My Team", partner)}

  courses = [["F & B Fundamentals", "Discover the art and science of food and beverages with our comprehensive course. Designed for aspiring chefs, hospitality professionals, and food enthusiasts, this program covers essential culinary techniques, advanced cooking methods, and beverage pairing principles. Learn from industry experts through hands-on practice and interactive lessons. Explore global cuisines, master presentation skills, and understand the business aspects of the food and beverage industry. Enhance your knowledge of food safety, nutrition, and sustainable practices. Whether you're starting a new career or refining your skills, this course provides the tools and knowledge needed to excel. Join us and embark on a flavorful journey that blends passion with professionalism.", "course_banner.jpeg"]]

  courses.each { |title, description, banner| create_course(title, description, banner) }

  course = Course.first

  modules = [["Body Language", "Welcome to your next lesson on body language. The key to unlocking genuine warmth and hospitality with our guests lies in mastering positive body language. It's about the silent messages we send through our gestures, facial expressions, and posture."],
             ["Etiquette & Manners", "Welcome to your new lesson on Etiquette and Manners. Etiquette and manners are the silent ambassadors of our hotel's reputation. They speak volumes about our dedication to excellence, ensuring every guest feels welcomed and respected."],
             ["Grooming And Hygiene", "Elevate your personal and professional image with our Grooming and Hygiene course. Designed for individuals seeking to enhance their appearance and health, this program covers essential grooming techniques, skincare routines, and hygiene practices."],
             ["Guest Complaints", "In this session, we're going to delve deep into the strategies that ensure every guest leaves our establishment not just satisfied, but feeling genuinely valued and cared for."]]

  modules.each { |title, description| create_module(title, description, course) }

  course_module = CourseModule.first

  lessons = [
    ["Overview", "It is the unspoken communication between human beings", "https://vimeo.com/948577869"],
    ["Gestures", "Right gestures nails it all", "https://vimeo.com/948577869"],
    ["Zone Distance", "Each person has his own personal territory", "https://vimeo.com/948577869"],
    ["Do's and Dont's", "What you should do and what shouldn't", "https://vimeo.com/948577869"]
  ]

  lessons.each { |title, description, url| create_lesson(title, description, url, course_module) }

  quizzes = [
    ["What does crossing your arms typically signify in body language?", "Openness", "Defensiveness", "Happiness", "Interest", "B"],
    ["Which of the following body language cues often indicates that a person is nervous or anxious?", "Leaning forward", "Making direct eye contact", "Fidgeting with objects", "Smiling broadly", "C"],
    ["When someone mirrors your body language, it generally means they are", "Distracted", "Disinterested", "Opposing you", "Building rapport", "D"],
    ["Standing with hands on hips is generally seen as a gesture of:", "Submission", "Dominance or confidence", "Confusion", "Relaxation", "B"]
  ]

  quizzes.each do |question, a, b, c, d, ans|
    create_quiz(question, a, b, c, d, ans, course_module)
  end
end