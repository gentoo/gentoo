# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="A high quality set of animated mouse cursors"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/${PN/xcursors/cursors}-tad-${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/cursors"

src_install() {
	dodir /usr/share/cursors/xorg-x11
	cp -pPR "${S}"/* "${D}"/usr/share/cursors/xorg-x11/ || die
}

pkg_postinst() {
	einfo "To use this set of cursors, edit or create the file ~/.Xdefaults"
	einfo "and add the following line (for example):"
	einfo "Xcursor.theme: gentoo"
	einfo ""
	einfo "You can change the size by adding a line like:"
	einfo "Xcursor.size: 48"
	einfo ""
	einfo "Also, to globally use this set of mouse cursors edit the file:"
	einfo "   /usr/local/share/cursors/xorg-x11/default/index.theme"
	einfo "and change the line:"
	einfo "    Inherits=[current setting]"
	einfo "to (for example)"
	einfo "    Inherits=gentoo"
	einfo ""
	einfo "Note this will be overruled by a user's ~/.Xdefaults file."
	einfo ""
	ewarn "If you experience flickering, try setting the following line in"
	ewarn ""
	ewarn "the Device section of your xorg.conf file:"
	ewarn "    Option  \"HWCursor\"  \"false\""
	einfo ""
	einfo "The three sets installed are gentoo, gentoo-silver and gentoo-blue."
}
