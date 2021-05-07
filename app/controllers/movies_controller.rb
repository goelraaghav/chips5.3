class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @sort = params[:sort] || session[:sort]
    @ratings_to_show = setup_ratings_to_show_array.each_with_object({}) { |k, h| h[k] = 1 } || session[:ratings]
    @movies = Movie.with_ratings(@ratings_to_show.keys).order(@sort)
    session[:sort], session[:ratings] = @sort, @ratings_to_show
    
    
    if params[:sort].nil? && params[:ratings].nil?
      session.clear
#     elsif session[:sort] || session[:ratings]
#       redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    end
  end
  
  
#   def index
#     # Deal with movie ratings now...
#     @all_ratings = Movie.get_possible_ratings

#     # If user has specified 1 or more ratings, then update session ratings
#     unless params[:ratings].nil?
#       @filtered_ratings = params[:ratings]
#       session[:filtered_ratings] = @filtered_ratings
#     end

#     # If the user has specified a sorting mechanism, update session sorting mechanism
#     if params[:sorting_mechanism].nil?
#       # If user didn't specify a sorting mechanism, then we're going to sort by the
#       # sorting mechanism in our sessions
#     else
#       session[:sorting_mechanism] = params[:sorting_mechanism]
#     end

#     if params[:sorting_mechanism].nil? && params[:ratings].nil? && session[:filtered_ratings]
#       @filtered_ratings = session[:filtered_ratings]
#       @sorting_mechanism = session[:sorting_mechanism]
#       flash.keep
#       redirect_to movies_path({order_by: @sorting_mechanism, ratings: @filtered_ratings})
#     end

#     @movies = Movie.all

#     # Filter movies based on rating if our sessions hash has any ratings in it
#     if session[:filtered_ratings]
#       @movies = @movies.select{ |movie| session[:filtered_ratings].include? movie.rating }
#     end

#     # title_sort symbol was placed in the params
#     if session[:sorting_mechanism] == "title"
#       @movies = @movies.sort! { |a,b| a.title <=> b.title }
#       @movie_highlight = "hilite"
#     elsif session[:sorting_mechanism] == "release_date"
#       @movies = @movies.sort! { |a,b| a.release_date <=> b.release_date }
#       @date_highlight = "hilite"
#     else
      
#     end
#   end

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
  
  helper_method :append_class_helper_title
  helper_method :append_class_helper_release_date
  
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
  
  def append_class_helper_title(class_name)
    if params[:sort] == 'title'
      return class_name
    end
  end
  
    def append_class_helper_release_date(class_name)
    if params[:sort] == 'release_date'
      return class_name
    end
  end

end
