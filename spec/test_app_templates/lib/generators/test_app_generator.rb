require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../spec/test_app_templates", __FILE__)

  def remove_index
    remove_file "public/index.html"
    remove_file 'app/assets/images/rails.png'
  end

  def run_blacklight_generator
    say_status("warning", "GENERATING BL", :yellow)

    generate 'blacklight:install'
  end

  # def copy_blacklight_catalog_controller
  #   copy_file "app/controllers/catalog_controller.rb", :force => true
  # end
end