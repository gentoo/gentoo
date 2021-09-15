# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"

PYTHON_COMPAT=( python3_{7..9} )

inherit desktop meson python-any-r1 readme.gentoo-r1 vala xdg-utils

DESCRIPTION="Set of GObject and Gtk objects for connecting to Spice servers and a client GUI"
HOMEPAGE="https://www.spice-space.org https://cgit.freedesktop.org/spice/spice-gtk/"

LICENSE="LGPL-2.1"
SLOT="0"
SRC_URI="https://www.spice-space.org/download/gtk/${P}.tar.xz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+gtk3 +introspection lz4 mjpeg policykit sasl smartcard usbredir vala wayland webdav"

# TODO:
# * check if sys-freebsd/freebsd-lib (from virtual/acl) provides acl/libacl.h
# * use external pnp.ids as soon as that means not pulling in gnome-desktop
RDEPEND="
	>=dev-libs/glib-2.46:2
	dev-libs/json-glib:0=
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/gstreamer:1.0[introspection?]
	media-libs/opus
	sys-libs/zlib
	virtual/jpeg:0=
	>=x11-libs/cairo-1.2
	>=x11-libs/pixman-0.17.7
	gtk3? ( x11-libs/gtk+:3[introspection?] )
	introspection? ( dev-libs/gobject-introspection )
	dev-libs/openssl:0=
	lz4? ( app-arch/lz4 )
	sasl? ( dev-libs/cyrus-sasl )
	smartcard? ( app-emulation/qemu[smartcard] )
	usbredir? (
		sys-apps/hwids
		>=sys-apps/usbredir-0.4.2
		virtual/libusb:1
		policykit? (
			sys-apps/acl
			>=sys-auth/polkit-0.110-r1
		)
	)
	webdav? (
		net-libs/phodav:2.0
		>=net-libs/libsoup-2.49.91 )
"
# TODO: spice-gtk has an automagic dependency on x11-libs/libva without a
# configure knob. The package is relatively lightweight so we just depend
# on it unconditionally for now. It would be cleaner to transform this into
# a USE="vaapi" conditional and patch the buildsystem...
RDEPEND="${RDEPEND}
	amd64? ( x11-libs/libva:= )
	arm64? ( x11-libs/libva:= )
	x86? ( x11-libs/libva:= )
"
DEPEND="${RDEPEND}
	>=app-emulation/spice-protocol-0.14.3
	dev-perl/Text-CSV
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

BDEPEND="
	$(python_gen_any_dep '
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/pyparsing[${PYTHON_USEDEP}]
	')
"

python_check_deps() {
	has_version "dev-python/six[${PYTHON_USEDEP}]" &&
	has_version "dev-python/pyparsing[${PYTHON_USEDEP}]"
}

src_prepare() {
	default
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_feature gtk3 gtk)
		$(meson_feature introspection)
		$(meson_use mjpeg builtin-mjpeg)
		$(meson_feature policykit polkit)
		$(meson_feature lz4)
		$(meson_feature sasl)
		$(meson_feature smartcard)
		$(meson_feature usbredir)
		$(meson_feature vala vapi)
		$(meson_feature webdav)
		$(meson_feature wayland wayland-protocols)
	)

	if use usbredir; then
		emesonargs+=(
			-Dusb-acl-helper-dir=/usr/libexec
			-Dusb-ids-path=/usr/share/misc/usb.ids
		)
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	make_desktop_entry spicy Spicy "utilities-terminal" "Network;RemoteAccess;"
	readme.gentoo_create_doc
}
