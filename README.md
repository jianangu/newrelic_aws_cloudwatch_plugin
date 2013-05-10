# New Relic AWS

This tool provides the metric collection agents for the following New Relic plugins:

- EC2
- EBS
- ELB
- RDS
- SQS
- SNS
- ElastiCache

Overview versions of the plugins above are also available.

## Dependencies
- A single t1.micro EC2 instance (in any region)
- Ruby (>= 1.8.7)
- Rubygems (>= 1.3.7)
- Bundler `gem install bundler`

## Install
1. Download the latest tagged version from `https://github.com/newrelic-platform/newrelic_aws_cloudwatch_extension/tags`
2. Extract to the location you want to run the extention from
3. Run `cp config/newrelic_plugin.yml.example config/newrelic_plugin.yml`
4. Edit `config/newrelic_plugin.yml`
5. Run `bundle install`
6. Run `bundle exec ./bin/newrelic_aws`

## Notes

- CloudWatch detailed monitoring is recommended, please enable when available.
- Chart x-axis (time) is off by 60 seconds, due to CloudWatch's lag & lack of New Relic backfill (end time) support.
- Latest data point is used to fill gaps in low resolution metrics.
- Can use services like Upstart, Systemd, Runit, and Monit to manage the process.
