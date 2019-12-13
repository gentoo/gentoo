# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Motif-based widget to display a grid of cells as a spreadsheet"
HOMEPAGE="http://xbae.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"
# tests need X display
# and are interactive so virtualx will not help
RESTRICT="test"

RDEPEND="
	x11-libs/motif:0
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-tmpl.patch
	"${FILESDIR}"/${P}-lxmp.patch
	"${FILESDIR}"/${P}-Makefile.in.patch
)

src_configure() {
	econf --enable-production
}

src_test() {
	emake -C examples
	emake -C examples/testall clean
}

src_install() {
	default

	insinto /usr/share/aclocal
	doins ac_find_xbae.m4

	if use examples; then
		find examples -name '*akefile*' -delete || die
		rm examples/{testall,extest} || die
		dodoc -r examples
	fi
	if use doc; then
		rm doc/{,images/}Makefile* || die
		docinto html
		dodoc -r doc/.
	fi

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
