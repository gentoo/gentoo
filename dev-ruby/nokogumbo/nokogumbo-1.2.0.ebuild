# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/nokogumbo/nokogumbo-1.2.0.ebuild,v 1.1 2014/12/25 08:04:32 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Nokogiri interface to the Gumbo HTML5 parser"
HOMEPAGE="https://github.com/rubys/nokogumbo"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+="dev-libs/gumbo"

ruby_add_rdepend ">=dev-ruby/nokogiri-1.6.5-r1"

each_ruby_configure() {
	${RUBY} -Cext/nokogumboc extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/nokogumboc V=1
	cp ext/nokogumboc/nokogumboc.so lib/ || die
}
