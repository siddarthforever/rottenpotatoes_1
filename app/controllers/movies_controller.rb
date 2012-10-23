class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  def index
    #session.clear
       @all_ratings = Set.new
       all_rating = Movie.select(:rating)
       all_rating.each do |rate|
         @all_ratings.add(rate.getRating)
       end
    	 
	if !params[:filter].nil? 
	    session.delete(:filter_rating)
            session[:filter_rating] = params[:filter]
	else
	    if !params[:ratings].nil?
		session.delete(:filter_rating)
		session[:filter_rating] = params[:ratings]
	    else
		if session[:filter_rating].nil?
		   temp = {}
		   @all_ratings.to_a.each do |rtr|
			temp[rtr] = "#{rtr}"
		   end
                   session[:filter_rating] = temp
		end
	    end	
	end
	
	if !params[:sort].nil?
	   session.delete(:filter_sort)
	   session[:filter_sort] = params[:sort]
	end
	   
	@movies = Movie.where(:rating => session[:filter_rating].is_a?(Hash) ? session[:filter_rating].keys : session[:filter_rating] ).order(session[:filter_sort])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    flash.keep
    redirect_to movies_path(:sort => session[:filter_sort], :filter => session[:filter_rating])
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
    flash.keep
    redirect_to movies_path(:sort => session[:filter_sort], :filter => session[:filter_rating])
  end

end
