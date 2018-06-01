# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY=" ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="A fast XML parser and Object marshaller"
HOMEPAGE="http://www.ohler.com/ox/ https://github.com/ohler55/ox"
SRC_URI="https://github.com/ohler55/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"

KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cext/ox extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/ox
	cp ext/ox/ox$(get_modname) lib/ox/ || die
}

each_ruby_test() {
	${RUBY} test/tests.rb || die
}
