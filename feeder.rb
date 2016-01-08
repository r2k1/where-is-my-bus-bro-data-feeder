require_relative 'auckland_transport'
require 'pry'

Pry::ColorPrinter.pp(AucklandTranport.get_data(106))
