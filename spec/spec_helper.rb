$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# Unit tests get confused if these are already set..
ENV.delete("MEGAPHONE_FLUENT_PORT")
ENV.delete("MEGAPHONE_FLUENT_MONITORING_PORT")
require 'megaphone/client'
