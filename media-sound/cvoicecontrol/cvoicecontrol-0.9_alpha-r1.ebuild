# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${P/_/}"

DESCRIPTION="Console based speech recognition system"
HOMEPAGE="http://www.kiecza.net/daniel/linux"
SRC_URI="http://www.kiecza.net/daniel/linux/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-gentoo-2.patch"
	"${FILESDIR}/${P}-tinfo.patch" #647166
)

src_prepare() {
	default
	# Handle documentation with dohtml instead.
	sed \
		-e "s:SUBDIRS = docs:#SUBDIRS = docs:" \
		-i cvoicecontrol/Makefile.am || die

	eautoreconf #647166

	sed \
		-e "s/install-data-am: install-data-local/install-data-am:/" \
		-i Makefile.in || die
}

src_install () {
	HTML_DOCS=( cvoicecontrol/docs/en/*.html )
	default
}
