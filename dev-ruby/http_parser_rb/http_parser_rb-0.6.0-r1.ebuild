# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/http_parser_rb/http_parser_rb-0.6.0-r1.ebuild,v 1.2 2015/03/20 16:10:27 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_NAME="http_parser.rb"

inherit ruby-fakegem

DESCRIPTION="Simple callback-based HTTP request/response parser"
HOMEPAGE="http://github.com/tmm1/http_parser.rb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cext/ruby_http_parser extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/ruby_http_parser V=1
	cp ext/ruby_http_parser/ruby_http_parser.so lib/ || die
}
