# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit gnome.org vala meson python-any-r1 xdg

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="https://wiki.gnome.org/Projects/gtk-vnc"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+introspection pulseaudio sasl +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gdk-pixbuf-2.36.0:2
	>=dev-libs/libgcrypt-1.8.0:0=
	>=net-libs/gnutls-3.6.0:0=
	>=sys-libs/zlib-1.2.11
	sasl? ( >=dev-libs/cyrus-sasl-2.1.27 )
	>=x11-libs/gtk+-3.22.0:3[introspection?]
	>=x11-libs/cairo-1.15.0
	>=x11-libs/libX11-1.6.5
	pulseaudio? ( >=media-sound/pulseaudio-11.0 )
	introspection? ( >=dev-libs/gobject-introspection-1.56.0:= )
"
# Keymap databases code is generated with python3; configure picks up $PYTHON exported from python-any-r1_pkg_setup
# perl for pod2man
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-lang/perl-5
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/1.0.0-honor-python-ver.patch
)

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_feature introspection)
		$(meson_feature pulseaudio)
		$(meson_feature sasl)
		$(meson_feature vala with-vala)
	)

	if use elibc_musl; then
		emesonargs+=( -Dwith-coroutine=gthread )
	else
		emesonargs+=( -Dwith-coroutine=auto )
	fi

	meson_src_configure
}
