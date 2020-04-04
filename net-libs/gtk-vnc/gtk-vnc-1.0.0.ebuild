# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit gnome.org vala meson python-any-r1 xdg

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="https://wiki.gnome.org/Projects/gtk-vnc"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+introspection pulseaudio sasl +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.42.0:2
	>=x11-libs/gdk-pixbuf-2.12.0:2
	>=dev-libs/libgcrypt-1.5.0:0=
	>=net-libs/gnutls-3.1.18:0=
	>=sys-libs/zlib-1.2.5
	sasl? ( >=dev-libs/cyrus-sasl-2.1.26 )
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	>=x11-libs/cairo-1.2.0
	>=x11-libs/libX11-1.6.5
	pulseaudio? ( >=media-sound/pulseaudio-10.0 )
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
	# Few fixes from origin/master + optionality patches filed as https://gitlab.gnome.org/GNOME/gtk-vnc/merge_requests/6
	"${WORKDIR}"/patches
	"${FILESDIR}"/${PV}-honor-python-ver.patch
)

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
	# Don't add -O2 explicitly to CFLAGS
	sed -i -e "/'-O2'/d" meson.build
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		$(meson_feature pulseaudio)
		$(meson_feature sasl)
		-Denable-werror=false
		-Dwith-coroutine=auto # gthread on windows, libc ucontext elsewhere; neither has extra deps
		$(meson_use vala with-vala)
	)
	meson_src_configure
}
