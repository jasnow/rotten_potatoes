class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    @sorted = params[:sortby]
    @filter_by = params[:ratings]

    if @sorted == nil && @filter_by == nil
      @sorted = session[:sortby]
      @filter_by = session[:ratings]
      flash.keep
      redirect_to :action => "index", :sortby => @sorted, :ratings => @filter_by if @sorted || @filter_by
    end

    if @filter_by
      @movies = Movie.where(:rating => @filter_by.keys).find(:all, :order => @sorted)
    else
      @filter_by = {}
      @movies = Movie.find(:all, :order => @sorted)      
    end

    session[:sortby] = @sorted
    session[:ratings] = @filter_by
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
