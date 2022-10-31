# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"

PYTHON_COMPAT=( python3_{8..11} )

inherit desktop meson optfeature python-any-r1 readme.gentoo-r1 vala xdg

DESCRIPTION="Set of GObject and Gtk objects for connecting to Spice servers and a client GUI"
HOMEPAGE="https://www.spice-space.org https://cgit.freedesktop.org/spice/spice-gtk/"
if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/spice/spice-gtk.git"
	inherit git-r3

	SPICE_PROTOCOL_VER=9999
else
	SRC_URI="https://www.spice-space.org/download/gtk/${P}.tar.xz"
	SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-meson-0.63.patch.xz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

	SPICE_PROTOCOL_VER=0.14.3
fi

LICENSE="LGPL-2.1"
SLOT="0"
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
	media-libs/libjpeg-turbo:=
	sys-libs/zlib
	>=x11-libs/cairo-1.2
	>=x11-libs/pixman-0.17.7
	x11-libs/libX11
	gtk3? ( x11-libs/gtk+:3[introspection?] )
	introspection? ( dev-libs/gobject-introspection )
	dev-libs/openssl:=
	lz4? ( app-arch/lz4 )
	sasl? ( dev-libs/cyrus-sasl )
	smartcard? ( app-emulation/qemu[smartcard] )
	usbredir? (
		sys-apps/hwdata
		>=sys-apps/usbredir-0.4.2
		virtual/libusb:1
		policykit? (
			sys-apps/acl
			>=sys-auth/polkit-0.110-r1
		)
	)
	webdav? (
		net-libs/phodav:2.0
		>=net-libs/libsoup-2.49.91:2.4
	)
"
# TODO: spice-gtk has an automagic dependency on media-libs/libva without a
# configure knob. The package is relatively lightweight so we just depend
# on it unconditionally for now. It would be cleaner to transform this into
# a USE="vaapi" conditional and patch the buildsystem...
RDEPEND="${RDEPEND}
	amd64? ( media-libs/libva:= )
	arm64? ( media-libs/libva:= )
	x86? ( media-libs/libva:= )
"
DEPEND="${RDEPEND}
	>=app-emulation/spice-protocol-${SPICE_PROTOCOL_VER}"
BDEPEND="
	dev-perl/Text-CSV
	dev-util/glib-utils
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	$(python_gen_any_dep '
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/pyparsing[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${WORKDIR}"/${P}-meson-0.63.patch
)

python_check_deps() {
	python_has_version "dev-python/six[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pyparsing[${PYTHON_USEDEP}]"
}

src_prepare() {
	default

	use vala && vala_setup
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

	if use elibc_musl; then
		emesonargs+=(
			-Dcoroutine=gthread
		)
	fi

	if use usbredir; then
		emesonargs+=(
			-Dusb-acl-helper-dir=/usr/libexec
			-Dusb-ids-path="${EPREFIX}"/usr/share/hwdata/usb.ids
		)
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	if use usbredir && use policykit; then
		# bug #775554 (and bug #851657)
		fowners root:root /usr/libexec/spice-client-glib-usb-acl-helper
		fperms 4755 /usr/libexec/spice-client-glib-usb-acl-helper
	fi

	make_desktop_entry spicy Spicy "utilities-terminal" "Network;RemoteAccess;"
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "Sound support (via pulseaudio)" media-plugins/gst-plugins-pulse
}
