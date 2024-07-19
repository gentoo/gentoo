# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-xcursors/}"

DESCRIPTION="A simple crispy white-grey xcursor theme"
HOMEPAGE="https://store.kde.org/p/999829/"
SRC_URI="mirror://gentoo/11313-${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="x11-libs/libXcursor"

src_install() {
	insinto /usr/share/icons
	doins -r pearlgrey/
}
