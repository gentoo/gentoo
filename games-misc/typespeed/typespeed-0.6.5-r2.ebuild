# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Test your typing speed, and get your fingers CPS"
HOMEPAGE="https://typespeed.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses:0=
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-musl.patch
	"${FILESDIR}"/${P}-use-extern.patch
	"${FILESDIR}"/${P}-link-tinfo.patch
)

src_prepare() {
	default
	sed -i -e '/^CC =/d' \
		src/Makefile.am \
		testsuite/Makefile.am || die
	rm -r m4 || die #bug 417265
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	dodoc doc/README
}
