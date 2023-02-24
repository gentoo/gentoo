# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unified widget and session management libs for Xfce"
HOMEPAGE="
	https://gitlab.xfce.org/xfce/libxfce4windowing/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~loong ~ppc ~riscv ~x86"
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
		>=x11-libs/libwnck-3.14:3
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	wayland? (
		>=dev-util/wayland-scanner-1.15
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-no-x.patch
)

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable wayland gdk-wayland)
		$(use_enable wayland wayland-scanner)
		$(use_enable wayland wayland-client)
		$(use_enable X libwnck)
		$(use_enable X gdk-x11)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
