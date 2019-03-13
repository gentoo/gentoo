# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/_/}

DESCRIPTION="Console based speech recognition system"
HOMEPAGE="http://www.kiecza.net/daniel/linux"
SRC_URI="http://www.kiecza.net/daniel/linux/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-gentoo-2.patch" )

src_prepare() {
	default
	sed -i -e "s/install-data-am: install-data-local/install-data-am:/" Makefile.in || die "sed failed"
	# Handle documentation with dohtml instead.
	sed -i -e "s:SUBDIRS = docs:#SUBDIRS = docs:" cvoicecontrol/Makefile.in || die "sed #2 failed"
}

src_install () {
	HTML_DOCS=( cvoicecontrol/docs/en/*.html )
	default
}
