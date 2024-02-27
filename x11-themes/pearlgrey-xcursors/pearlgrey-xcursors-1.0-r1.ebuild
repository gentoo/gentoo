# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-xcursors/}"

DESCRIPTION="A simple crispy white-grey xcursor theme"
HOMEPAGE="https://store.kde.org/p/999829/"
SRC_URI="mirror://gentoo/11313-${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86"

RDEPEND="x11-libs/libXcursor"

src_install() {
	insinto /usr/share/cursors/xorg-x11/pearlgrey
	doins -r pearlgrey/cursors
}

pkg_postinst() {
	elog "To use this set of cursors, edit or create the file ~/.Xdefaults"
	elog "and add the following line:"
	elog "Xcursor.theme: ${MY_PN}"
	elog
	elog "You can change the size by adding a line like:"
	elog "Xcursor.size: 48"
	elog
	elog "Also, to globally use this set of mouse cursors edit the file:"
	elog "    ${EROOT}/usr/share/cursors/xorg-x11/default/index.theme"
	elog "and change the line:"
	elog "    Inherits=[current setting]"
	elog "to"
	elog "    Inherits=${MY_PN}"
	elog
	elog "Note this will be overruled by a user's ~/.Xdefaults file."
	elog

	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your xorg.conf file:"
	ewarn "    Option  \"HWCursor\"  \"false\""
}
