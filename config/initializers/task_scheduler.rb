require 'rubygems'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.start_new
logger = Rails.logger
logger.info('Starting the scheduler...')

# Roberto 2013-11-04 modified to 15 minutes
scheduler.every("15m") do
  logger.info('Searching twitter...')
  ts = TwitterSearch.new
  ts.perform
end
