# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP=""
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
IUSE=""

DEPEND+=" test? ( sys-process/lsof )"

ruby_add_rdepend "
	dev-ruby/faraday-net_http:2
	>=dev-ruby/ruby2_keywords-0.0.4
"
ruby_add_bdepend "test? (
		>=dev-ruby/test-unit-2.4
		>=dev-ruby/connection_pool-2.2.2
		dev-ruby/rack
		dev-ruby/webmock
	)"

all_ruby_prepare() {
	# Remove bundler support.
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d ; 1irequire "yaml"' Rakefile || die
	# Avoid loading all lib files since some of them require unpackaged dependencies.
	sed -e '/[Cc]overall/ s:^:#:' \
		-e '/lib\/\*\*/ s:^:#:' \
		-e '/simplecov/ s:^:#:' \
		-e '/SimpleCov/,/end/ s:^:#:' \
		-e '/pry/ s:^:#:' \
		-i spec/spec_helper.rb || die

	sed -e '/git ls-files/ s:^:#:' \
		-e "s:_relative ': './:" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid multipart tests that require an unpackaged dependency
	# that appears to be no longer maintained.
	#rm -f spec/faraday/request/multipart_spec.rb || die
	#sed -e '/multipart_parser/ s:^:#:' \
	#	-i spec/support/helper_methods.rb || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true each_fakegem_test
}
