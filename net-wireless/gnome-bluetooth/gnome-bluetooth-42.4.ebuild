# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
inherit gnome.org meson python-any-r1 xdg

DESCRIPTION="Bluetooth graphical utilities integrated with GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeBluetooth"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="3/13" # subslot = libgnome-bluetooth-3 soname version
IUSE="gtk-doc +introspection sendto test"
RESTRICT="!test? ( test )"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-libs/glib-2.44:2
	>=gui-libs/gtk-4.4:4[introspection?]
	media-libs/gsound
	>=gui-libs/libadwaita-1.1:1
	>=x11-libs/libnotify-0.7.0
	virtual/libudev:=
	>=sys-power/upower-0.99.14:=
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${DEPEND}
	acct-group/plugdev
	virtual/udev
	>=net-wireless/bluez-5
	sendto? ( !net-wireless/gnome-bluetooth:2 )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.9 )
	virtual/pkgconfig
	test? (
		$(python_gen_any_dep '
			>=dev-python/python-dbusmock-0.26.0[${PYTHON_USEDEP}]
			dev-python/dbus-python[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	if use test; then
		python_has_version ">=dev-python/python-dbusmock-0.26.0[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/dbus-python[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	# Check for python is unconditional
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use sendto)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
}
