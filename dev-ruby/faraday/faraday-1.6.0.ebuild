# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="spec"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="HTTP/REST API client library with pluggable components"
HOMEPAGE="https://github.com/lostisland/faraday"
SRC_URI="https://github.com/lostisland/faraday/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

DEPEND+=" test? ( sys-process/lsof )"

ruby_add_rdepend "
	dev-ruby/faraday-httpclient:1
	dev-ruby/faraday-net_http_persistent:1
	dev-ruby/faraday-net_http:1
	dev-ruby/faraday-patron:1
	dev-ruby/faraday-rack:1
	>=dev-ruby/multipart-post-1.2.0 <dev-ruby/multipart-post-3
	>=dev-ruby/ruby2_keywords-0.0.4
"
ruby_add_bdepend "test? (
		>=dev-ruby/test-unit-2.4
		>=dev-ruby/connection_pool-2.2.2
		dev-ruby/rack
		>=dev-ruby/rack-test-0.6
		dev-ruby/webmock
	)"

all_ruby_prepare() {
	# Remove bundler support.
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d ; 1irequire "yaml"' Rakefile || die
	sed -i -e '/bundler/,/^fi/ s:^:#:' script/test || die
	# Avoid loading all lib files since some of them require unpackaged dependencies.
	sed -e '/[Cc]overall/ s:^:#:' \
		-e '/lib\/\*\*/ s:^:#:' \
		-e '/simplecov/ s:^:#:' \
		-e '/SimpleCov/,/end/ s:^:#:' \
		-e '/pry/ s:^:#:' \
		-e '3igem "faraday-net_http", "~> 1.0"; gem "faraday-net_http_persistent", "~> 1.0"' \
		-i spec/spec_helper.rb || die

	sed -e '/git ls-files/ s:^:#:' \
		-e "s:_relative ': './:" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid multipart tests that require an unpackaged dependency
	# that appears to be no longer maintained.
	rm -f spec/faraday/request/multipart_spec.rb || die
	sed -e '/multipart_parser/ s:^:#:' \
		-i spec/support/helper_methods.rb || die

	# Remove specs for unpackaged adapters
	rm -f spec/faraday/adapter/{em_http,em_synchrony,excon,httpclient}_spec.rb || die

	# Remove unpackaged adapters. These packages where part of earlier
	# faraday versions but since we do not package their dependencies
	# they never worked on a pure Gentoo install. We are taking this
	# approach so we can add ruby32 compatibility to faraday:1 for
	# those adapters that we do support.
	sed -e '/require.*\(em_http\|em_synchrony\|excon\)/ s:^:#:' \
		-i lib/faraday.rb || die
	sed -e '/\(em_http\|em_synchrony\|excon\)/ s:^:#:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Make this adapter optional since it comes with a long list of
	# dependencies.
	if ! has_version "dev-ruby/typhoeus:1" ; then
		rm -f  spec/faraday/adapter/typhoeus_spec.rb || die
	fi

	# Avoid a spec that gets tripped up by recent rack encoding changes.
	sed -e '/encodes rack compat/ s/it/xit/' -i spec/faraday/params_encoders/nested_spec.rb || die
}

each_ruby_prepare() {
	# Make sure the test scripts use the right ruby interpreter
	sed -i -e 's:ruby:'${RUBY}':' script/* || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true each_fakegem_test

	# Sleep some time to allow the sinatra test server to die
	einfo "Waiting for test server to stop"
	sleep 10
}
