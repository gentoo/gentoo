# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-base/gpe-dm/gpe-dm-0.52.ebuild,v 1.1 2013/08/26 14:36:00 patrick Exp $

# NOTE to bumpers: Version 0.52 changes don't affect Gentoo.
# Please don't bump to that version.

GPE_TARBALL_SUFFIX="bz2"
inherit eutils gpe autotools

DESCRIPTION="GPE Desktop Manager"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}
	${DEPEND}
	x11-apps/xinit"

src_unpack() {
	gpe_src_unpack "$@"

	# The default path is ugly and might confuse people with
	# /etc/X11/xinit
	sed -i -e 's;/etc/X11;/etc/X11/gpe-dm;' gpe-dm.c \
		|| die "Failed to sed file gpe-dm.c"

	# Dont use /etc/init.d/gpe-dm, use
	# /etc/init.d/xdm instead
	epatch "${FILESDIR}/${PN}-noinitd.patch"
	eautoreconf
}

src_install() {
	gpe_src_install "$@"

	dodir /etc/X11/gpe-dm/Xinit.d
	exeinto /etc/X11/gpe-dm
	doexe "${FILESDIR}/Xinit"
	doexe "${FILESDIR}/Xserver"
}

pkg_postinst() {
	einfo "You *really* should edit /etc/X11/gpe-dm/Xserver now to set the"
	einfo "Xserver parameters (resolution, mouse, kb, ..)."
	einfo "If you need some X services to be started upon X initialization,"
	einfo "add them to /etc/X11/gpe-dm/Xinit.d/ ."
}
