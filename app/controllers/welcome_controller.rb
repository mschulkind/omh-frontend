class WelcomeController < ApplicationController
  def index
    @chart_data = []

    if params[:schema_name].present?
      data_points = omh.get_data_points(
        schema_namespace: 'omh', schema_version: '1.0',
        schema_name: params[:schema_name])

      data_types = data_points.flat_map {|dp| dp.body.keys}.uniq
      data_types -= ['effective_time_frame']

      @chart_data = []
      data_types.each do |type|
        data = {}
        name = nil

        data_points.each do |datum|
          p = datum.body[type]
          if p.value
            data[datum.body.effective_time_frame.date_time] = p.value
            name ||= type + " (#{p.unit})"
          end
        end

        @chart_data << {name: name, data: data}
      end
    end
  end
end
