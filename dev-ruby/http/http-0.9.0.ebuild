# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/http/http-0.9.0.ebuild,v 1.1 2015/08/01 05:14:10 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="An easy-to-use client library for making requests from Ruby"
HOMEPAGE="https://github.com/tarcieri/http"

LICENSE="MIT"
SLOT="0.8"
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
}
