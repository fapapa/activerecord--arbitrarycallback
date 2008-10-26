require 'arbitrary_callback'

ActiveRecord::Base.send(:include, LeoneImage::ArbitraryCallback)
