# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="a calendar dockapp"
HOMEPAGE="https://wmcalendar.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"

RDEPEND="
	dev-libs/libical
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( ../{BUGS,CHANGES,HINTS,README,TODO} )

S=${WORKDIR}/${P}/Src

PATCHES=( "${FILESDIR}"/${P}-exit-sin-and-cos.patch
	"${FILESDIR}"/${P}-rename_kill_func.patch
	"${FILESDIR}"/${P}-ical.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/wmcalendar-c99.patch
	"${FILESDIR}"/0001-fix-obvious-typo-causing-out-of-bounds-memory-access.patch
)

src_compile() {
	tc-export CC PKG_CONFIG
	default
}
