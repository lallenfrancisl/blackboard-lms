class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[ show edit update destroy enroll unenroll proceed]

  # GET /courses or /courses.json
  def index
    @enrolled_courses = current_user.courses
    @other_courses = Course.all - @enrolled_courses
  end

  # GET /courses/1 or /courses/1.json
  def show
    @course_modules = @course.course_modules
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def enroll
    service = CourseManagementService.instance
    result = service.enroll!(current_user, @course)

    if result == :duplicate
      message = "Already enrolled in this course"
    elsif result == :ok
      message = "Successfully enrolled for the course"
    end

    redirect_to course_url(@course), notice: message
  end

  def unenroll
    service = CourseManagementService.instance
    result = service.undo_enroll!(current_user, @course)

    if result == :not_enrolled
      message = "You are not enrolled in this course"
    elsif result == :ok
      message = "Success"
    end

    redirect_to course_url(@course), notice: message
  end

  def proceed
    service = CourseManagementService.instance
    enrollment = service.proceed(current_user, @course)
    redirect_to course_module_lesson_path(@course, enrollment.current_module_id || 1, enrollment.current_lesson_id || 1)
  end
  def search
    service = CourseManagementService.instance
    @keyword = params[:term]
    @search_results = service.search(@keyword)
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :description, :banner)
    end
end
