# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${P/_/}"

DESCRIPTION="Console based speech recognition system"
HOMEPAGE="http://www.kiecza.net/daniel/linux/"
SRC_URI="http://www.kiecza.net/daniel/linux/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-2.patch
	"${FILESDIR}"/${P}-tinfo.patch #64716
	# Handle documentation with HTML_DOCS instead
	"${FILESDIR}"/${P}-automake.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	local HTML_DOCS=( cvoicecontrol/docs/en/*.html )

	default
}
