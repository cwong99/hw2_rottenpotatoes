class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    logger.debug("Debugging.......")
    logger.debug("params "+ params[:sortBy].to_s)
    logger.debug("params " + params[:ratings].to_s )
    
    ratingArray = Array.new
    if params[:ratings]!=nil
      x=params[:ratings]
      x.each do |key,value|
        ratingArray.push(key)
      end
    end
    if ratingArray.length==0&&params[:sortBy]==nil
      flash[:ratingArray]=nil
      flash[:sortedBy]=nil
    end
    logger.debug(ratingArray.length)
   

    if params[:sortBy]==nil
      if flash[:sortedBy]!=nil
        params[:sortBy]=flash[:sortedBy]
      end
    end
    if ratingArray.length==0
      if flash[:ratingArray]!=nil
        ratingArray = flash[:ratingArray]
      end
    end
    logger.debug("Before if statement")
    logger.debug(params[:sortedBy])
    logger.debug(ratingArray.length)
    if params[:sortBy]!=nil
      
         if ratingArray.length > 0
            @movies =Movie.order(params[:sortBy]).where(:rating => ratingArray)
         else
           @movies =Movie.order(params[:sortBy]).all
         end
    else 
         if ratingArray.length > 0
           @movies=Movie.where(:rating => ratingArray)
         else
           @movies = Movie.all
         end
    end
     flash[:ratingArray] = ratingArray
     flash[:sortedBy] = params[:sortBy]

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

  def ratingChecked(rating)
    logger.debug("in ratingChecked")
    checked=false
    if flash[:ratings] != nil
       if flash[:rating].include?rating
          checked=true
       end
    end
    return checked
  end
end
