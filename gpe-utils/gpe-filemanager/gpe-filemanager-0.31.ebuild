# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-utils/gpe-filemanager/gpe-filemanager-0.31.ebuild,v 1.1 2010/02/27 01:15:30 miknix Exp $

GPE_TARBALL_SUFFIX="bz2"
inherit gpe

DESCRIPTION="File Manager for the GPE Palmtop Environment"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
	gpe-base/libgpewidget
	gnome-base/gnome-vfs
	dev-libs/dbus-glib"
RDEPEND="${RDEPEND}
	gpe-base/gpe-icons
	${DEPEND}"

GPE_DOCS="ChangeLog"

src_unpack() {
	gpe_src_unpack "$@"

	# Fixes failing test suite
	echo "gpe-filemanager.desktop.in.in" >> po/POTFILES.in
	echo "hildon/gpe-filemanager.desktop.in.in" >> po/POTFILES.in
	echo "gpe-filemanager.desktop.in.in" >> po/POTFILES.in
	echo "hildon/gpe-filemanager.desktop.in.in" >> po/POTFILES.in
}
