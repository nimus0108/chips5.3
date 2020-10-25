class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if !params.has_key?(:ratings) && !params.has_key?(:sort_by)
      params[:ratings] = session[:ratings]
      @ratings_to_show = session[:ratings].keys
      params[:sort_by] = session[:sort_by]

      redirect_to movies_path({"sort_by" => params[:sort_by], "ratings" => params[:ratings]})
    end

    if params.has_key?(:ratings)
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = params[:ratings]
    else
      if session.has_key?(:ratings)
        @ratings_to_show = session[:ratings].keys
      else
        @ratings_to_show = Movie.all_ratings
      end

    end

    @movies = Movie.with_ratings(@ratings_to_show)

    if params.has_key?(:sort_by)
      @sort_by = params[:sort_by]
      @movies = @movies.order(@sort_by)
      session[:sort_by] = @sort_by
    else
      if session.has_key?(:sort_by)
        @sort_by = session[:sort_by]
        @movies = @movies.order(@sort_by)
      end
    end
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
end
