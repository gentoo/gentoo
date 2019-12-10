# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 udev vala

DESCRIPTION="GObject library for managing information about real and virtual OSes"
HOMEPAGE="https://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

IUSE="+introspection +vala test"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

# Unsure about osinfo-db-tools rdep, but at least fedora does it too
RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=dev-libs/libxml2-2.6.0
	>=dev-libs/libxslt-1.0.0
	sys-apps/hwids[pci,usb]
	sys-apps/osinfo-db-tools
	sys-apps/osinfo-db
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
# perl dep is for pod2man, and configure.ac checks for it too now
# Tests can use net-misc/curl, but they are automatically skipped if curl is not found, and
# if it is found, then those tests are skipped at runtime if LIBOSINFO_NETWORK_TESTS is unset.
# Due to potential network-sandbox we aren't enabling them (and one of them fails at 1.2.0).
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-libs/gobject-introspection-common
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.10
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		<=sys-apps/osinfo-db-20190304
	)
	vala? ( $(vala_depend) )
" # osinfo-db-20190319 and newer make tests fail; next libosinfo will remove the failing tests (moved to a future osinfo-db itself)

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
