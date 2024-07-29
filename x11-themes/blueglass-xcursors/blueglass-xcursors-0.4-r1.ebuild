# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="5532-BlueGlass-XCursors-3D-${PV}"

DESCRIPTION="A high quality set of Xfree 4.3.0 animated mouse cursors"
HOMEPAGE="https://store.kde.org/p/999915/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P:5}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sparc x86"

RDEPEND="x11-libs/libXcursor"

# Note: although the package name is BlueGlass, the tarball & authors directions
# use the directory 'Blue'.
src_install() {
	insinto /usr/share/cursors/xorg-x11/Blue
	doins -r Blue/cursors

	einstalldocs
}

pkg_postinst() {
	einfo "To use this set of cursors, edit or create the file ~/.Xdefaults"
	einfo "and add the following line:"
	einfo "Xcursor.theme: Blue"
	einfo ""
	einfo "You can change the size by adding a line like:"
	einfo "Xcursor.size: 48"
	einfo ""
	einfo "To globally use this set of mouse cursors edit the file:"
	einfo "   ${EROOT}/usr/share/cursors/xorg-x11/default/index.theme"
	einfo "and change the line:"
	einfo "    Inherits=[current setting]"
	einfo "to"
	einfo "    Inherits=Blue"
	einfo ""
	einfo "Note this will be overruled by a user's ~/.Xdefaults file."
	einfo

	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your XF86Config:"
	ewarn "Option  \"HWCursor\"  \"false\""
}
