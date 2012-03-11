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
   
    redirectPath=false
    redirectURL="/movies?"
    if params[:sortBy]==nil
      if flash[:sortedBy]!=nil
        params[:sortBy]=flash[:sortedBy]
        logger.debug("will not redirect sortby")
      else 
        if session[:sortedBy]!=nil
           logger.debug("displaying session sortedBy")
           logger.debug(session[:sortedBy])
           flash[:sortedBy]=session[:sortedBy]
           session.delete(:sortedBy)
           logger.debug("redirect at sortedBy")
           
           redirectPath=true
        end
      end
    end
    if ratingArray.length==0
      if flash[:ratingArray]!=nil
        ratingArray = flash[:ratingArray]
        logger.debug("shouldn't redirectory")
      else
        if session[:ratingArray]!=nil&&session[:ratingArray].length>0
          flash[:ratingArray] = session[:ratingArray]
          flash[:ratings] = session[:ratings]
          logger.debug("redirect at ratings")
          logger.debug(session[:ratingArray])
          session.delete(:ratingArray)
          session.delete(:ratings)
          redirectPath=true
        end
      end
    end
    if redirectPath==true
      logger.debug("at redirect path")
      logger.debug(flash[:sortedBy])
      logger.debug(flash[:ratings])
     redirect_to movies_path({:sortBy=>flash[:sortedBy],:ratings=>flash[:ratings]})
     #redirect_to movies_path({:sortedBy=>"title",:ratings=>{"G"=>"1", "PG"=>"1"}})
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
     flash[:ratings]=params[:ratings]
     flash[:sortedBy] = params[:sortBy]
     session[:ratingArray] = ratingArray
     session[:ratings]=params[:ratings]
     session[:sortedBy] = params[:sortBy]

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
