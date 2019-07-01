class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A(\w+[+\-.]?)+@([a-z\d\-]+\.?)+[a-z]+\z/i
  # I like MY_REGEX better since it seems cleaner
  #MY_REGEX          = /\A(\w+[+\-.]?)+@([a-z\d\-]+\.?)+[a-z]+\z/i
  #TUTORIAL_REGEX    = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
end
