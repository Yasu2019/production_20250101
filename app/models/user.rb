# frozen_string_literal: true

class User < ApplicationRecord
  devise :two_factor_authenticatable,
         otp_secret_encryption_key: ENV['OTP_SECRET_KEY']
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :validatable
end
