# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson udev vala xdg

DESCRIPTION="GObject library for managing information about real and virtual OSes"
HOMEPAGE="https://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

IUSE="gtk-doc +introspection +vala test"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

# Unsure about osinfo-db-tools rdep, but at least fedora does it too
RDEPEND="
	>=dev-libs/glib-2.44:2
	net-libs/libsoup:3.0
	>=dev-libs/libxml2-2.6.0
	>=dev-libs/libxslt-1.0.0
	sys-apps/hwdata
	sys-apps/osinfo-db-tools
	sys-apps/osinfo-db
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
"
DEPEND="${RDEPEND}"
# perl dep is for pod2man for automagic manpage building
BDEPEND="
	dev-lang/perl
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.10
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PV}-build-Add-option-to-disable-libsoup3.patch
)

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc enable-gtk-doc)
		$(meson_feature introspection enable-introspection)
		$(meson_use test enable-tests)
		$(meson_feature vala enable-vala)
		-Dlibsoup3=enabled
		-Dwith-pci-ids-path="${EPREFIX}"/usr/share/hwdata/pci.ids
		-Dwith-usb-ids-path="${EPREFIX}"/usr/share/hwdata/usb.ids
	)
	meson_src_configure
}
