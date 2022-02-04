# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A fun clock applet for your desktop featuring swimming fish"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"

RDEPEND="x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gtk.patch
	"${FILESDIR}"/${P}-no_display.patch )

DOCS=( ALL_I_GET_IS_A_GRAY_BOX AUTHORS ChangeLog CODING README )

src_prepare() {
	default
	sed -i -e "s/\$(CC)/& \$(LDFLAGS)/" Makefile || die #331891
}

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
}
