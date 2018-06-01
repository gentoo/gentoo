# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST="test spec NO_CONNECTION=true"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Allows stubbing HTTP requests and setting expectations on HTTP requests"
HOMEPAGE="https://github.com/bblimke/webmock"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/addressable-2.3.6 >=dev-ruby/crack-0.3.2 dev-ruby/hashdiff"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/rspec:3
	>=dev-ruby/test-unit-3.0.0
	dev-ruby/rack
	>=dev-ruby/httpclient-2.8.0
	>=dev-ruby/patron-0.4.18
	>=dev-ruby/http-0.8.0:0.8 )"

all_ruby_prepare() {
	# Remove bundler support
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '/simplecov/I s:^:#:' -e '1i gem "http", "~>0.8"' spec/spec_helper.rb || die
	sed -i -e '1igem "test-unit"' test/test_helper.rb || die

	# There is now optional support for curb and typhoeus which we don't
	# have in Gentoo yet. em_http_request is available in Gentoo but its
	# version is too old.
	sed -i -e '/\(curb\|typhoeus\|em-http\)/d' spec/spec_helper.rb || die
	rm spec/acceptance/{typhoeus,curb,excon,em_http_request}/* || die

	# Avoid httpclient specs that require network access, most likely
	# because mocking does not fully work.
	sed -i -e '/httpclient streams response/,/^  end/ s:^:#:' \
		-e '/are detected when manually specifying Authorization header/,/^    end/ s:^:#:' \
		spec/acceptance/httpclient/httpclient_spec.rb
}

each_ruby_test() {
	${RUBY} -S rake test NO_CONNECTION=true || die
	${RUBY} -S rspec-3 spec || die

	einfo "Delay to allow the test server to stop"
	sleep 10
}
