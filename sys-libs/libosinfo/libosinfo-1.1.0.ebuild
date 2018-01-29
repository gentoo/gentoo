# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 udev vala

DESCRIPTION="GObject library for managing information about real and virtual OSes"
HOMEPAGE="http://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

IUSE="+introspection +vala test"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# Unsure about osinfo-db-tools rdep, but at least fedora does it too
RDEPEND="
	>=dev-libs/glib-2.36.0:2
	>=net-libs/libsoup-2.42:2.4
	>=dev-libs/libxml2-2.6.0
	>=dev-libs/libxslt-1.0.0
	sys-apps/hwids[pci,usb]
	sys-apps/osinfo-db-tools
	sys-apps/osinfo-db
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
# perl dep is for pod2man, and configure.ac checks for it too now
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-libs/gobject-introspection-common
	>=dev-util/gtk-doc-am-1.10
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	test? ( dev-libs/check )
	vala? ( $(vala_depend) )
"

src_prepare() {
	gnome2_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--with-usb-ids-path=/usr/share/misc/usb.ids \
		--with-pci-ids-path=/usr/share/misc/pci.ids \
		--disable-static \
		$(use_enable test tests) \
		$(use_enable introspection) \
		$(use_enable vala) \
		--disable-coverage
}
