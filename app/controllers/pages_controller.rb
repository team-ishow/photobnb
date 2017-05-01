class PagesController < ApplicationController
  def index #views/index.html.erbを表示させるというアクション
    @users = User.all
  end

  def search
    if params[:search].present?

      session[:address] = params[:search]
      
      if params["lat"].present? & params["lng"].present? 
        @latitude = params["lat"]
        @longitude = params["lng"]

        geolocation = [@latitude,@longitude]
      else
        geolocation = Geocoder.coordinates(params[:search])
        @latitude = geolocation[0]
        @longitude = geolocation[1]
      end

      @listings = Listing.where(active: true).near(geolocation, 1, order: 'distance')

    # 検索欄が空欄の場合
    else

      @listings = Listing.where(active: true).all
      @latitude = @listings.to_a[0].latitude
      @longitude = @listings.to_a[0].longitude  

    end

    # Ransack q のチェックボックス一覧
    if params[:q].present? 

      if params[:q][:price_photo_gteq].present?
        session[:price_photo_gteq] = params[:q][:price_photo_gteq]
      else
        session[:price_photo_gteq] = nil
      end

      
      if params[:q][:price_photo_lteq].present?
        session[:price_photo_lteq] = params[:q][:price_photo_lteq]
      else
        session[:price_photo_lteq] = nil
      end

      if params[:q][:photo_type_eq_any].present?
        session[:photo_type_eq_any] = params[:q][:photo_type_eq_any]
        session[:Private] = session[:photo_type_eq_any].include?("個人写真")
        session[:Couple] = session[:photo_type_eq_any].include?("カップル写真")
        session[:Marriage] = session[:photo_type_eq_any].include?("結婚写真")
        session[:Family] = session[:photo_type_eq_any].include?("家族写真")
        session[:Others] = session[:photo_type_eq_any].include?("その他")        
      else
        session[:photo_type_eq_any] = ""
        session[:Private] = false
        session[:Couple] = false
        session[:Marriage] = false
        session[:Family] = false
        session[:Others] = false        
      end

      if params[:q][:photo_time_gteq].present?
        session[:photo_time_gteq] = params[:q][:photo_time_gteq]
      else
        session[:photo_time_gteq] = nil
      end


      if params[:q][:finish_time_gteq].present?
        session[:finish_time_gteq] = params[:q][:finish_time_gteq]
      else
        session[:finish_time_gteq] = nil
      end

    end 

    # Q条件をまとめたものをセッションQに入れる
    session[:q] = {"price_photo_gteq"=>session[:price_photo_gteq], "price_photo_lteq"=>session[:price_photo_lteq],  "photo_type_eq_any"=>session[:photo_type_eq_any], "photo_time_gteq"=>session[:photo_time_gteq], "finish_time_gteq"=>session[:finish_time_gteq]}


    # ransack検索
    @search = @listings.ransack(session[:q])
    @result = @search.result(distinct: true)

     #リスティングデータを配列にしてまとめる 
    @arrlistings = @result.to_a

    # start_date end_dateの間に予約がないことを確認.あれば削除
    if ( !params[:start_date].blank? && !params[:end_date].blank? )

      session[:start_date] = params[:start_date]
      session[:end_date] = params[:end_date]

      start_date = Date.parse(session[:start_date])
      end_date = Date.parse(session[:end_date])

      @listings.each do |listing|

        # check the listing is availble between start_date to end_date
        unavailable = listing.reservations.where(
            "(? <= start_date AND start_date <= ?)
              OR (? <= end_date AND end_date <= ?) 
              OR (start_date < ? AND ? < end_date)",
            start_date, end_date,
            start_date, end_date,
            start_date, end_date
        ).limit(1)

        # delete unavailable room from @listings
        if unavailable.length > 0
          @arrlistings.delete(listing) 
        end 
      end
    end
  end

  def ajaxsearch
    
    # まずajaxで送られてきた緯度経度をセッションに入れる
    if !params[:geolocation].blank?
      geolocation = params[:geolocation]
    end

    # まずajaxで送られてきた緯度経度をセッションに入れる
    if !params[:location].blank?
      session[:address] = params[:location]
    end

    @listings = Listing.where(active: true).near(geolocation, 1, order: 'distance')

    #リスティングデータを配列にしてまとめる 
    @arrlistings = @listings.to_a

    # start_date end_dateの間に予約がないことを確認.あれば削除
    if ( !session[:start_date].blank? && !session[:end_date].blank? )

      start_date = Date.parse(session[:start_date])
      end_date = Date.parse(session[:end_date])

      @listings.each do |listing|

        # check the listing is availble between start_date to end_date
        unavailable = listing.reservations.where(
            "(? <= start_date AND start_date <= ?)
              OR (? <= end_date AND end_date <= ?) 
              OR (start_date < ? AND ? < end_date)",
            start_date, end_date,
            start_date, end_date,
            start_date, end_date
        ).limit(1)

        # delete unavailable room from @listings
        if unavailable.length > 0
          @arrlistings.delete(listing) 
        end 
      end
    end

    respond_to :js
  
  end
end
