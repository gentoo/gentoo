# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A simple but powerful tool to set desktop wallpaper"
HOMEPAGE="https://sourceforge.net/projects/fvwm-crystal/"
SRC_URI="https://sourceforge.net/projects/fvwm-crystal/files/${PN}/${PV}/${P}.tar.gz/download -> ${P}-sourceforge.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	media-libs/imlib2[X]
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"
DOCS=( ChangeLog README TODO "${FILESDIR}"/README.en )
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_compile() {
	tc-export CC PKG_CONFIG
	emake -C src ${PN}
}

src_install() {
	dobin src/${PN}
	einstalldocs
}
