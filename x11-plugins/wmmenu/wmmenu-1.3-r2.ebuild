# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="a popup menu of icons like in AfterStep, as a dockapp"
HOMEPAGE="https://www.dockapps.net/wmmenu"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/gdk-pixbuf-xlib
	>=x11-libs/gdk-pixbuf-2.42.0:2
	>=x11-libs/libdockapp-0.7:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/dockapps"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

DOCS=( README TODO example/{apps,defaults,extract_icon_back} )

src_prepare() {
	default
	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
}

src_compile() {
	emake  CC="$(tc-getCC)"
}

src_install() {
	dobin wmmenu
	doman wmmenu.1
	einstalldocs
}
