# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unified widget and session management libs for Xfce"
HOMEPAGE="https://gitlab.xfce.org/xfce/libxfce4windowing/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0/4.19.6"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+introspection wayland X"
REQUIRED_USE="|| ( wayland X )"

RDEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gtk+-3.24.10:3[X?,introspection?,wayland?]
	>=x11-libs/gdk-pixbuf-2.42.8[introspection?]
	wayland? (
		>=dev-libs/wayland-1.20
	)
	X? (
		>=media-libs/libdisplay-info-0.1.1
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXrandr-1.5.0
		>=x11-libs/libwnck-3.14:3
	)
"
DEPEND="
	${RDEPEND}
	wayland? (
		>=dev-libs/wayland-protocols-1.25
	)
"
BDEPEND="
	>=dev-build/xfce4-dev-tools-4.19.2
	dev-lang/perl
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	wayland? (
		>=dev-util/wayland-scanner-1.15
	)
"

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable wayland)
		$(use_enable X x11)
		# these are not used by make check
		--disable-tests
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
