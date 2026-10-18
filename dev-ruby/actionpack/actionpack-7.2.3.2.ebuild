# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"
RUBY_FAKEGEM_GEMSPEC="actionpack.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit edo ruby-fakegem

DESCRIPTION="Eases web-request routing, handling, and response"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

ruby_add_rdepend "
	~dev-ruby/actionview-${PV}
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/nokogiri-1.8.5
	dev-ruby/racc
	>=dev-ruby/rack-2.2.4:*
	>=dev-ruby/rack-session-1.0.1
	>=dev-ruby/rack-test-0.6.3:*
	>=dev-ruby/rails-dom-testing-2.2:2
	>=dev-ruby/rails-html-sanitizer-1.6:1
	>=dev-ruby/useragent-0.16:0
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		~dev-ruby/activemodel-${PV}
		>=dev-ruby/capybara-3.39
		dev-ruby/launchy
		dev-ruby/minitest:5
		>=dev-ruby/msgpack-1.7.0
		>=dev-ruby/rack-cache-1.2:1.2
		>=dev-ruby/selenium-webdriver-4.20.0
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 5.0"

	gem "capybara", ">= 3.39"
	gem "launchy"
	gem "msgpack", ">= 1.7.0"
	gem "rack-cache", "~> 1.2"
	gem "selenium-webdriver", ">= 4.20.0"
	EOF
	rm ../Gemfile.lock || die

	# Avoid tests failing with rails-dom-testing 2.3 (fixed upstream)
	# https://github.com/rails/rails/issues/55093 (Still failing??)
	sed -e '/test_preserves_order_when_reading_from_cache_plus_rendering/askip "Fails with rails-dom-testing 2.3"' \
		-i test/controller/caching_test.rb || die

	# Avoid tests requiring chrome
	sed -e '/DrivenBySeleniumWith/,/^end/ s:^:#:' \
		-i test/abstract_unit.rb || die
	rm -f test/dispatch/system_testing/{driver,screenshot_helper,system_test_case}_test.rb || die
}

each_ruby_test() {
	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true
	case ${TEST_VERBOSE} in
		1|yes|true)
			local -x TESTOPTS="${TESTOPTS} --verbose"
			;;
	esac
	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake
}
