guard 'livereload' do
  watch(/.+\.(rb)/)
  watch(%r{app/views/.+\.(erb|haml|slim)})
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg|gif))).*}) { |m| "/assets/#{m[3]}" }
end
