# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

MY_PN="Chameleon"

DESCRIPTION="Style neutral scalable cursor theme"
HOMEPAGE="http://www.egregorion.net/2007/03/26/chameleon/"

COLOURS="Anthracite DarkSkyBlue SkyBlue Pearl White"
SRC_URI=""
for COLOUR in ${COLOURS} ; do
	SRC_URI="${SRC_URI} http://www.egregorion.net/works/${MY_PN}-${COLOUR}-${PV}.tar.bz2"
done

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	dodir /usr/share/cursors/xorg-x11/
	for COLOUR in ${COLOURS}; do
		for SIZE in Large Regular Small; do
			local name=${MY_PN}-${COLOUR}-${SIZE}
			cp -r "${WORKDIR}"/${name}-${PV} \
				"${ED}"/usr/share/cursors/xorg-x11/${name}
		done
	done
}

pkg_postinst() {
	elog "To use one of these sets of cursors, edit or create the file ~/.Xdefaults"
	elog "and add the following line:"
	elog "Xcursor.theme: ${MY_PN}-Pearl-Regular"
	elog "(for example)"
	elog
	elog "You can change the size by adding a line like:"
	elog "Xcursor.size: 48"
	elog
	elog "Also, to globally use this set of mouse cursors edit the file:"
	elog "    /usr/share/cursors/xorg-x11/default/index.theme"
	elog "and change the line:"
	elog "    Inherits=[current setting]"
	elog "to"
	elog "    Inherits=${MY_PN}-Pearl-Regular"
	elog
	elog "Note this will be overruled by a user's ~/.Xdefaults file."
	elog
	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your xorg.conf file:"
	ewarn "    Option  \"HWCursor\"  \"false\""
}
