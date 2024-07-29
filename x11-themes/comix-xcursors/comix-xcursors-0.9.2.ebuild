# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ComixCursors"

DESCRIPTION="X11 mouse theme with a comics feeling"
HOMEPAGE="
	https://limitland.de/comixcursors
	https://gitlab.com/limitland/comixcursors
"
SRC_URI="
	https://limitland.gitlab.io/comixcursors/${MY_PN}-${PV}.tar.bz2
	lefthanded? ( https://limitland.gitlab.io/comixcursors/${MY_PN}-LH-${PV}.tar.bz2 )
	opaque? ( https://limitland.gitlab.io/comixcursors/${MY_PN}-Opaque-${PV}.tar.bz2 )
	lefthanded? ( opaque? ( https://limitland.gitlab.io/comixcursors/${MY_PN}-LH-Opaque-${PV}.tar.bz2 ) )
"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sparc x86"
IUSE="lefthanded opaque"

RDEPEND="x11-libs/libXcursor"

src_install() {
	insinto /usr/share/cursors/xorg-x11
	doins -r "${S}"/*
}
