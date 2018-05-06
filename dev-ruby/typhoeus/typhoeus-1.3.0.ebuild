# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md UPGRADE.md"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Runs HTTP requests in parallel while cleanly encapsulating handling logic"
HOMEPAGE="https://rubygems.org/gems/typhoeus/
	https://github.com/typhoeus/typhoeus"

LICENSE="Ruby"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ethon-0.9.0"

ruby_add_bdepend "test? ( dev-ruby/json >=dev-ruby/faraday-0.9 >=dev-ruby/sinatra-1.3 >=dev-ruby/redis-3.0 )"

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' -i Rakefile spec/spec_helper.rb || die
}
