# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Obsidian"

DESCRIPTION="A shiny and clean xcursor theme"
HOMEPAGE="https://store.kde.org/p/999984/"
SRC_URI="mirror://gentoo/73135-${MY_PN}.tar.bz2"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86"

RDEPEND="x11-libs/libXcursor"

src_install() {
	insinto /usr/share/icons/Obsidian
	doins -r cursors
}
