# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

# Gem only contains lib code, and github repository has no tags.
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

SRC_URI="https://github.com/maik/xml-simple/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Easy API to maintain XML. A Ruby port of Grant McLean's Perl module XML::Simple"
HOMEPAGE="https://github.com/maik/xml-simple"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

each_ruby_test() {
	cd test || die
	for i in *.rb; do
		${RUBY} -I../lib ${i} || die
	done
}
