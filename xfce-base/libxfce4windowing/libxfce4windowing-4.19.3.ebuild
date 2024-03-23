# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unified widget and session management libs for Xfce"
HOMEPAGE="https://gitlab.xfce.org/xfce/libxfce4windowing/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+introspection wayland X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	>=dev-libs/glib-2.68.0
	>=x11-libs/gtk+-3.24.0:3[X?,introspection?,wayland?]
	>=x11-libs/gdk-pixbuf-2.40.0[introspection?]
	wayland? (
		>=dev-libs/wayland-1.15
	)
	X? (
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libwnck-3.14:3
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
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
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
