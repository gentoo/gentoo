# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="An easy-to-use client library for making requests from Ruby"
HOMEPAGE="https://github.com/tarcieri/http"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/addressable-2.3
	>=dev-ruby/http-cookie-1.0
	>=dev-ruby/http-form_data-1.0.1:1.0
	>=dev-ruby/http_parser_rb-0.6.0 =dev-ruby/http_parser_rb-0.6*"

ruby_add_bdepend "
	test? ( dev-ruby/certificate_authority dev-ruby/rspec-its )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/end/ s:^:#:' \
		-e '1irequire "cgi"' spec/spec_helper.rb || die

	# Avoid specs that require network access
	sed -i -e '/.persistent/,/^  end/ s:^:#:' \
		spec/lib/http_spec.rb || die
	sed -i -e '/with non-ASCII URLs/,/^    end/ s:^:#:' \
		spec/lib/http/client_spec.rb || die
}
