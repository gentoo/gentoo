# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-actions/nautilus-actions-3.2.4.ebuild,v 1.3 2014/12/19 13:38:50 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Configures programs to be launched when files are selected in Nautilus"
HOMEPAGE="http://www.nautilus-actions.org/ https://git.gnome.org/browse/nautilus-actions/"

LICENSE="GPL-2 FDL-1.3"
SLOT="3"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.30:2
	>=dev-libs/libxml2-2.6:2
	dev-libs/libunique:3
	>=gnome-base/libgtop-2.23.1:2
	>=gnome-base/nautilus-3
	sys-apps/util-linux
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libICE
	>=x11-libs/libSM-1

	!gnome-extra/nautilus-actions:2
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35.5
	virtual/pkgconfig
"

src_prepare() {
	# install docs in /usr/share/doc/${PF}, not ${P}
	sed -i -e "s:/doc/@PACKAGE@-@VERSION@:/doc/${PF}:g" \
		Makefile.{am,in} \
		docs/Makefile.{am,in} \
		docs/nact/Makefile.{am,in} || die
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-deprecated \
		--disable-gconf \
		--with-gtk=3
}

src_install() {
	gnome2_src_install
	# Do not install COPYING
	rm -v "${ED}usr/share/doc/${PF}"/COPYING* || die
}
