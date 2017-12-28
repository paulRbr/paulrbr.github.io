install:
	bundle check || bundle install

run: install
	bundle exec middleman

build: install
	bundle exec middleman build
