# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Window manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfwm4/start
	https://gitlab.xfce.org/xfce/xfwm4
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="opengl startup-notification +xcomposite +xpresent"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gtk+-3.24.0:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXres
	x11-libs/pango
	>=x11-libs/libwnck-3.14:3
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/xfconf-4.13:=
	opengl? ( media-libs/libepoxy:=[X(+)] )
	startup-notification? ( x11-libs/startup-notification )
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXfixes
	)
	xpresent? ( x11-libs/libXpresent )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-libs/glib
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable opengl epoxy)
		$(use_enable startup-notification)
		$(use_enable xcomposite compositor)
		$(use_enable xpresent)
		--enable-randr
		--enable-render
		--enable-xi2
		--enable-xsync
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
