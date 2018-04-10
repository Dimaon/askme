require 'openssl'

class User < ApplicationRecord
  # параметры работы модуля шифрования полей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates :username, length: { maximum: 40 }
  validates :username, format: {with: /\w/ }
  validates :email, format: {with: /\A[a-zA-Z\d\.]+@[a-zA-Z\d]*\.+([a-zA-Z\.]{2,})\z/,
    message: "incorrect email"}

  attr_accessor :password

  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  before_save :encrypt_password
  before_validation { username.downcase! }

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
