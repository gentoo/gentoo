# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libosinfo/libosinfo-0.2.12.ebuild,v 1.1 2015/06/07 14:16:29 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"

inherit gnome2 udev vala

DESCRIPTION="GObject library for managing information about real and virtual OSes"
HOMEPAGE="http://libosinfo.org/"
SRC_URI="http://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="+introspection +vala test"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2:2
	>=dev-libs/libxslt-1.0.0:=
	dev-libs/libxml2:=
	net-libs/libsoup-gnome:2.4
	sys-apps/hwids
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
	>=dev-util/gtk-doc-am-1.10
	virtual/pkgconfig
	test? ( dev-libs/check )
	vala? ( $(vala_depend) )
"

src_configure() {
	# --enable-udev is only for rules.d file install
	gnome2_src_configure \
		--disable-static \
		$(use_enable test tests) \
		$(use_enable introspection) \
		$(use_enable vala) \
		--enable-udev \
		--disable-coverage \
		--with-html-dir=/usr/share/doc/${PF}/html \
		--with-udev-rulesdir="$(get_udevdir)"/rules.d \
		--with-usb-ids-path=/usr/share/misc/usb.ids \
		--with-pci-ids-path=/usr/share/misc/pci.ids
}
