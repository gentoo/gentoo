# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="dockapp that displays how much data you've received on each eth and ppp device"
SRC_URI="mirror://sourceforge/wmdownload/${P}.tar.gz"
HOMEPAGE="http://wmdownload.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/libdockapp-0.7:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )
DOCS=( CHANGELOG CREDITS HINTS README TODO )

src_prepare() {
	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
	default
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)"
}
