class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_save { self.city_st = zip_code.to_region unless zip_code.blank? }
  before_save { self.city_st = nil if zip_code.blank? } 
  before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
	
  has_secure_password 
  validates :password, length: { minimum: 6 }, on: :create

                     

  #acts as follower gem
  acts_as_followable
  acts_as_follower



  #paperclip/imagemagick configuration
  has_attached_file :avatar, 
    styles: {
      small:  '63x63^',
      medium: '134x134^'
    }, 
    convert_options: {
      small: " -gravity center -crop '63x63+0+0'",
      medium: " -gravity center -crop '134x134+0+0'"
    }
    validates_attachment_content_type :avatar, 
      :content_type => ["image/jpg", "image/jpeg", "image/png"]


 
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  


#this is for the Wednesday (Here's What's New!) Newsletter in NY
  def self.whats_new_wednesday_ny
    charity_ids = Event.select{|event| event.start_time >= (Time.now - 4.hours)}.select{|event| event.created_at >= (Time.now - 4.hours - 7.days)}.select{|event| event.zip_code.present?}.select{|event| event.city_st[-2..-1] == "NY"}.map{|x| x.charity_id}.uniq
    charities = Charity.where(id: charity_ids).select{|charity| charity.zip_code.present?}
    #users = User.select{|user| user.zip_code.present?}.select{|user| user.city_st[-2..-1] == "NY"}.select{|user| user.wednesday_news != "off"}
    users_char = User.select{|user| user.zip_code.present?}.select{|user| user.city_st.present?}.select{|user| user.city_st[-2..-1] == "NY"}.select{|user| user.type == "Charity"}.select{|user| user.email_updates != "off"}
    users_phil = User.select{|user| user.zip_code.present?}.select{|user| user.city_st.present?}.select{|user| user.city_st[-2..-1] == "NY"}.select{|user| user.type == "Philanthropist"}.select{|user| user.email_updates != "off"}
    if charities.any?
      UserMailer.wednesday_ny_email(charities, users_char, users_phil).deliver
    end
  end


#this is for the Sunday (Happening This Week!) Newsletter in NY
  def self.this_week_sunday_ny
    charity_ids = Event.select{|event| event.start_time >= (Time.now - 4.hours)}.select{|event| event.start_time < (Time.now - 4.hours + 7.days)}.select{|event| event.zip_code.present?}.select{|event| event.city_st[-2..-1] == "NY"}.map{|x| x.charity_id}.uniq
    charities = Charity.where(id: charity_ids).select{|charity| charity.zip_code.present?}
    #users = User.select{|user| user.zip_code.present?}.select{|user| user.city_st[-2..-1] == "NY"}.select{|user| user.sunday_news != "off"}
    users_char = User.select{|user| user.zip_code.present?}.select{|user| user.city_st.present?}.select{|user| user.city_st[-2..-1] == "NY"}.select{|user| user.type == "Charity"}.select{|user| user.email_updates != "off"}
    users_phil = User.select{|user| user.zip_code.present?}.select{|user| user.city_st.present?}.select{|user| user.city_st[-2..-1] == "NY"}.select{|user| user.type == "Philanthropist"}.select{|user| user.email_updates != "off"}
    if charities.any?
      UserMailer.sunday_ny_email(charities, users_char, users_phil).deliver
    end
  end

  
  

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end