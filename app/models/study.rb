# frozen_string_literal: true

class Study < ApplicationRecord
  belongs_to :primary_researcher, class_name: 'Researcher'
  has_many :study_participations, dependent: nil

  geocoded_by :address
  after_validation :geocode if Rails.env.production?

  scope :closed, -> { where('close_date > ?', Time.zone.today) }

  def address
    [city, state, country].compact.join(', ')
  end

  def short_addr
    fully_digital? ? 'Online' : "#{city}, #{state}"
  end

  def timeline
    if total_sessions == 1
      "#{total_hours} #{total_hours == 1 ? 'hour' : 'hours'} in one session"
    else
      "#{total_hours} #{total_hours == 1 ? 'hour' : 'total hours'} in #{total_sessions} sessions over the course of #{duration}"
    end
  end

  def fully_digital?
    false
  end

  def open?
    Time.zone.today > start_date && Time.zone.today < end_date
  end

  def age_range
    return 'All ages' unless min_age? || max_age?

    if min_age?
      max_age? ? "#{min_age}-#{max_age}" : "#{min_age} and up"
    else
      "#{max_age} and under"
    end
  end

  def duration_number
    return '' if duration.nil?

    duration.split[0]
  end

  def duration_factor
    return '' if duration.nil?

    duration.split[1]
  end
end
