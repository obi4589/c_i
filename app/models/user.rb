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
  validates :password, length: { minimum: 6 }     


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
      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


 
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

 
  

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end