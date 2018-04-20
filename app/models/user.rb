require 'openssl'

class User < ApplicationRecord
  # параметры работы модуля шифрования полей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions, dependent: :destroy

  validates :email, :username, presence: true
  before_validation { username.downcase! unless username.nil? }
  validates :email, :username, uniqueness: true
  validates :username, length: { maximum: 40 }
  validates :username, format: { with: /\A[\w]+\z/ }
  validates :email, format: { with: /\A[a-z\d_+.\-]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/,
    message: "incorrect email" }
  validates :header_color, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}+\z/}, allow_blank: true

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password

  def encrypt_password
    if self.password.present?
      # создаем т.н. "соль" - рандомная строка усложняющая задачу хакерам
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # создаем хэш-пароля - длинная уникальная строка, из которой невозможно восстановить исходный пароль
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  # служебный метод, преобразующий бинарную строку в 16-ричный формат
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    # сперва находим кондитата по email, он будет один т.к. email уникальный
    user = find_by(email: email)

    # Сравниваем password_hash
    if user.present? && user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end
end
