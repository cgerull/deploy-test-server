#!/usr/bin/env ruby

require 'json'

Dir.chdir(File.join(File.dirname(__FILE__), "../../helm/values"))
p Dir.glob('*').select { |f| File.directory? f }
