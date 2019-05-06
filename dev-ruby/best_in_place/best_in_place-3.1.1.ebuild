# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

# if ever needed
#GITHUB_USER="bernat"
#GITHUB_PROJECT="${PN}"
#RUBY_S="${GITHUB_USER}-${GITHUB_PROJECT}-*"

inherit virtualx ruby-fakegem

DESCRIPTION="In-place editor helper for Rails 3"
HOMEPAGE="https://github.com/bernat/best_in_place"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/actionpack-3.2:*
	>=dev-ruby/railties-3.2:*
"

ruby_add_bdepend "
	test? (
		dev-ruby/rdiscount
		dev-ruby/rspec-rails:3
		>=dev-ruby/nokogiri-1.5.0
		>=dev-ruby/capybara-1.1.2
		>=dev-ruby/rails-3.2
		>=dev-ruby/sqlite3-1.3.4-r1
		dev-ruby/bundler
		dev-ruby/combustion
		dev-ruby/jquery-rails
		dev-ruby/jquery-ui-rails
	)"

all_ruby_prepare() {
	sed -i \
		-e '/git ls-files/d' \
		${RUBY_FAKEGEM_GEMSPEC} || die

	# Tweak Gemfile so we can use it to run specs but can avoid missing
	# dependencies. Also use packaged versions of jquery and jquery-ui.
	sed -i -e '/\(rails-assets\|appraisal\)/ s:^:#:' \
		-e '2agem "rspec", "~>3.0"' \
		-e '2agem "jquery-rails"' -e '2agem "jquery-ui-rails"' \
		-e '/byebug/ s:^:#:' \
		-e '/\(launchy\|poltergeist\)/d' \
		Gemfile
	sed -i -e '/poltergeist/,/javascript_driver/ s:^:#:' spec/rails_helper.rb || die

	# Remove integration tests. They fail to run and depend on obsolete
	# poltergeist/phantomjs.
	rm -rf spec/integration || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rspec-3 spec || die
}
