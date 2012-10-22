class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def getParams
    
  end

  def index
    
    @all_ratings = Set.new
   # @movies = Movie.all
    all_rating = Movie.select(:rating)
    all_rating.each do |rate|
         @all_ratings.add(rate.getRating)
      end
    	#logger.debug "New post 4: #{params[:ratings].nil?}"
	#logger.debug "New post 14: #{params[:ratings].inspect}"
	
	if(!params[:ratings].nil?)
	    @chosen_rating = params[:ratings].keys
            #logger.debug "New post 3: #{@chosen_rating.inspect}"
	else
	    @chosen_rating = @all_ratings.to_a
        end   
        @val = params[:sort]
	#logger.debug "New post 5: #{@val.inspect}"
         if @val == 'title'
	   #logger.debug "New post 7: #{@chosen_rating.inspect}"
	   @movies = Movie.where(:rating => params[:filter].nil? ? @chosen_rating : params[:filter].keys ).order('title')
	 elsif @val == 'release_date'
	   #logger.debug "New post 8: #{@chosen_rating.inspect}"
	   @movies = Movie.where(:rating => params[:filter].nil? ? @chosen_rating : params[:filter].keys ).order('release_date')
	 else
	   #logger.debug "New post 9: #{@chosen_rating.inspect}"
	   @movies = Movie.where(:rating => @chosen_rating)
       end
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
