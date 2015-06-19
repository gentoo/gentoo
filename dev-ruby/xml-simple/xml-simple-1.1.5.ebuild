# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/xml-simple/xml-simple-1.1.5.ebuild,v 1.1 2015/02/21 05:07:46 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

# Gem only contains lib code, and github repository has no tags.
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

SRC_URI="https://github.com/maik/xml-simple/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Easy API to maintain XML. It is a Ruby port of Grant McLean's Perl module XML::Simple"
HOMEPAGE="https://github.com/maik/xml-simple"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

each_ruby_test() {
	cd test || die
	for i in *.rb; do
		${RUBY} -I../lib ${i} || die
	done
}
