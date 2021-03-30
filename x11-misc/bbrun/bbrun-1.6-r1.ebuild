# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="blackbox program execution dialog box"
HOMEPAGE="http://www.darkops.net/bbrun"
SRC_URI="http://www.darkops.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-list.patch
	"${FILESDIR}"/${P}-gcc-10.patch
)

src_prepare() {
	default
	sed -i -e "/LIBDIR =/s:lib:$(get_libdir):" bbrun/Makefile || die
}

src_compile() {
	emake -C ${PN} CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}/${PN}
	dodoc Changelog README
}
