module DateHelpers
  def human_date(date)
    letter_month    = date.strftime('%b')
    ordinalized_day = date.strftime('%e').to_i.ordinalize
    year            = date.strftime('%Y')

    "#{letter_month} #{ordinalized_day}, #{year}"
  end
end
