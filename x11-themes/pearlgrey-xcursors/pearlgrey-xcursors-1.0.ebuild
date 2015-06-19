# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/pearlgrey-xcursors/pearlgrey-xcursors-1.0.ebuild,v 1.2 2009/04/27 19:33:58 maekke Exp $

MY_PN=${PN/-xcursors/}
DESCRIPTION="A simple crispy white-grey xcursor theme"
HOMEPAGE="http://www.kde-look.org/content/show.php/PearlGrey?content=11313"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/11313-${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	insinto /usr/share/cursors/xorg-x11/${MY_PN}
	doins -r ${MY_PN}/cursors || die "doins failed"
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
	elog "    /usr/share/cursors/xorg-x11/default/index.theme"
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
