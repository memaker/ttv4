require 'rubygems'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.start_new
logger = Rails.logger
logger.info('Starting the scheduler...')
scheduler.every("30m") do
  logger.info('Searching twitter...')
  ts = TwitterSearch.new
  ts.perform
end
