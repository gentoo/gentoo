# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool vala

DESCRIPTION="A library for the X Keyboard Extension (high-level API)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/LibXklavier"
SRC_URI="https://people.freedesktop.org/~svu/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0/16"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="+introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.16:2=
	dev-libs/libxml2:2=
	x11-apps/xkbcomp
	x11-libs/libX11:=
	>=x11-libs/libXi-1.1.3:=
	x11-libs/libxkbfile:=
	>=x11-misc/xkeyboard-config-2.4.1-r3
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.4
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

PATCHES=( "${FILESDIR}"/clang-17.patch )

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	use vala && vala_setup

	econf \
		--disable-gtk-doc \
		$(use_enable introspection) \
		$(use_enable vala) \
		--with-xkb-base="${EPREFIX}"/usr/share/X11/xkb \
		--with-xkb-bin-base="${EPREFIX}"/usr/bin
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
