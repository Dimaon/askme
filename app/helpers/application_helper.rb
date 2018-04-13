module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def sklonenie(number, krokodil, krokodila, krokodilov)
    if number == nil || !number.is_a?(Numeric)
      # Если параметр пустой или не является числом, считаем что он нулевой.
      number = 0
    end

    # Так как склонение определяется последней цифрой в числе, вычислим остаток
    # от деления числа number на 10
    ostatok = number % 10

    # 5-9 или ноль — родительный падеж и множественное число (8 Кого?/Чего? —
    # крокодилов)
    if (ostatok >= 5 && ostatok <= 9) || (ostatok == 0) || ((11..14).include? number % 100)
      return krokodilov
    end

    # Для 1 — именительный падеж (Кто?/Что? — крокодил)
    if ostatok == 1
      return krokodil
    end

    # Для 2-4 — родительный падеж (2 Кого?/Чего? — крокодилов)
    if ostatok >= 2 && ostatok <= 4
      return krokodila
    end
  end
end
