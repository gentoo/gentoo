# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Collection of doom wad files from id"
HOMEPAGE="http://www.idsoftware.com/"
SRC_URI="mirror://gentoo/doom1.wad.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doomsday"

RDEPEND="doomsday? ( games-fps/doomsday )"
DEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /usr/share/doom-data
	doins *.wad
	if use doomsday; then
		# Make wrapper for doomsday
		make_wrapper doomsday-demo "jdoom -file \
			/usr/share/doom-data/doom1.wad"
		make_desktop_entry doomsday-demo "Doomsday - Demo"
	fi
}

pkg_postinst() {
	if use doomsday; then
		elog "To use the doomsday engine, run doomsday-demo"
	else
		elog "A Doom engine is required to play the wad"
		elog "Enable the doomsday use flag if you want to use"
		elog "	the doomsday engine"
	fi
}
