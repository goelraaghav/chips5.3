class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:sort] == 'title'
      @title_sort = params[:sort]
    elsif params[:sort] == 'release_date'
      @release_date_sort = params[:sort]
    end
    @sort = @title_sort || @release_date_sort
    @ratings_to_show = setup_ratings_to_show_array
    @ratings_hash = @ratings_to_show.each_with_object({}) { |k, h| h[k] = 1 }
    @movies = Movie.with_ratings(setup_ratings_to_show_array).order(@sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def setup_ratings_to_show_array
    if params[:ratings].nil?
      @ratings_to_show = []
    else
      @ratings_to_show = params[:ratings].keys
    end
  end
  

end
