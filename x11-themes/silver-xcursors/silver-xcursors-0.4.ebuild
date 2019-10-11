# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit readme.gentoo-r1

MY_P="5533-Silver-XCursors-3D-${PV}"
DESCRIPTION="A high quality set of Xfree 4.3.0 animated mouse cursors"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5533"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/$MY_P.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P:5}"

DOC_CONTENTS="To use this set of cursors, edit or create the file ~/.Xdefaults
and add the following line:
Xcursor.theme: Silver

You can change the size by adding a line like:
Xcursor.size: 48

Also, to globally use this set of mouse cursors edit the file:
	  /usr/share/cursors/xorg-x11/default/index.theme
and change the line:
	Inherits=[current setting]
to
	Inherits=Silver

Note this will be overruled by a user's ~/.Xdefaults file."

src_install() {
	insinto /usr/share/cursors/xorg-x11/Silver
	doins -r Silver/cursors
	einstalldocs

	DISABLE_AUTOFORMATTING="yes"
	readme.gentoo_create_doc
}

pkg_postinst() {
	DISABLE_AUTOFORMATTING="yes"
	readme.gentoo_print_elog

	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your xorg.conf file:"
	ewarn "    Option \"HWCursor\" \"false\""

}
