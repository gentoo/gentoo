# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_TASK_TEST="test spec NO_CONNECTION=true"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="webmock.gemspec"

inherit ruby-fakegem

DESCRIPTION="Allows stubbing HTTP requests and setting expectations on HTTP requests"
HOMEPAGE="https://github.com/bblimke/webmock"
SRC_URI="https://github.com/bblimke/webmock/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/addressable-2.8.0
	>=dev-ruby/crack-0.3.2
	>=dev-ruby/hashdiff-0.4.0:0
"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/rspec:3
	dev-ruby/rspec-retry
	>=dev-ruby/test-unit-3.0.0
	dev-ruby/rack
	dev-ruby/webrick
)"

all_ruby_prepare() {
	# Remove bundler support
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e '1igem "test-unit"' test/test_helper.rb || die

	# There is now optional support for curb and typhoeus which we don't
	# have in Gentoo yet. em_http_request is available in Gentoo but its
	# version is too old. patron's latest version is not compatible.
	# httpclient is no longer maintained and has various test failures.
	sed -i -e '/\(curb\|typhoeus\|em-http\|patron\|httpclient\)/ s:^:#:' spec/spec_helper.rb || die
	rm -f spec/acceptance/{typhoeus,curb,excon,em_http_request,patron,async_http_client,httpclient}/* || die

	# Drop tests for dev-ruby/http for now since this package only works with ruby26
	sed -i -e '/http_rb/ s:^:#:' spec/spec_helper.rb || die
	rm -f spec/acceptance/http_rb/* || die

	# Avoid specs that require network access
	sed -i -e '/when request is not stubbed/,/^      end/ s:^:#:' spec/acceptance/shared/callbacks.rb
}

each_ruby_test() {
	${RUBY} -S rake test NO_CONNECTION=true || die
	${RUBY} -S rspec-3 spec || die

	einfo "Delay to allow the test server to stop"
	sleep 10
}
