# Scrapinghub

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'scrapinghub'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scrapinghub


## Usage

Get Job Items

```ruby
  Scrapinghub::Scrapinghub.new("SCRAPING HUB API KEY").job_items(project: project_id, job: job_id)
```

##### Avaialbe methods:

* projects
* spiders - required param: { project: project_id }
* jobs - required param: { project: project_id }
* job - required param: { project: project_id, job: job_id }
* job_items - required param: { project: project_id, job: job_id }
* spider_items - required param: { project: project_id, spider: spider_id }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

