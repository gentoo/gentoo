# Copyright 1999-2020 Gentoo Authors
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

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-2.patch
	"${FILESDIR}"/${P}-tinfo.patch #64716
	# Handle documentation with HTML_DOCS instead
	"${FILESDIR}"/${P}-automake.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	HTML_DOCS=( cvoicecontrol/docs/en/*.html )
	default
}
