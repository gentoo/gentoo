# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/rodent/rodent-4.9.2.ebuild,v 1.3 2013/04/11 18:09:03 ago Exp $

EAPI=5
EAUTORECONF=yes
inherit xfconf

DESCRIPTION="A fast, small and powerful file manager and graphical shell"
HOMEPAGE="http://rodent.xffm.org/"
SRC_URI="mirror://sourceforge/xffm/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="experimental"

COMMON_DEPEND="x11-libs/libX11
	x11-libs/libSM
	dev-libs/libxml2
	>=dev-libs/glib-2.24
	x11-libs/gtk+:3
	>=x11-libs/cairo-1.8.10
	>=gnome-base/librsvg-2.26
	>=dev-libs/libzip-0.9
	sys-apps/file"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=( $(use_enable experimental) )
	DOCS=( ChangeLog README TODO )
	PATCHES=( "${FILESDIR}"/${P}-rupo.patch )
}

src_prepare() {
	sed -e "s:\$(bindir):\$(DESTDIR)\$(bindir):" -i Build/plugins/Makefile.am
	sed -e "/^Categories/s:Rodent:X-Rodent:" \
		-e "s/;;/;/" -i Build/*/*.desktop.in.in
	xfconf_src_prepare
}
