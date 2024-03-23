# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils vala

DESCRIPTION="Unified widget and session management libs for Xfce"
HOMEPAGE="
	https://docs.xfce.org/xfce/libxfce4ui/start
	https://gitlab.xfce.org/xfce/libxfce4ui/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="glade +introspection startup-notification system-info vala wayland X"
REQUIRED_USE="
	|| ( wayland X )
	vala? ( introspection )
"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3[introspection?,wayland?,X?]
	>=xfce-base/libxfce4util-4.17.2:=[introspection?,vala?]
	>=xfce-base/xfconf-4.12.0:=
	glade? ( >=dev-util/glade-3.5.0:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-1.66:= )
	system-info? (
		>=dev-libs/libgudev-232
		>=gnome-base/libgtop-2.24.0
		>=media-libs/libepoxy-1.2
	)
	X? (
		>=x11-libs/libICE-1.0.10
		>=x11-libs/libSM-1.2.3
		>=x11-libs/libX11-1.6.7
		startup-notification? ( >=x11-libs/startup-notification-0.4 )
	)
"
RDEPEND="
	${DEPEND}
"
DEPEND+="
	x11-base/xorg-proto
"
BDEPEND="
	dev-lang/perl
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_configure() {
	local myconf=(
		$(use_enable glade gladeui2)
		$(use_enable introspection)
		$(use_enable system-info glibtop)
		$(use_enable system-info epoxy)
		$(use_enable system-info gudev)
		$(use_enable startup-notification)
		$(use_enable vala)
		$(use_enable wayland)
		$(use_enable X libsm)
		$(use_enable X x11)
		--with-vendor-info=Gentoo
	)

	use vala && vala_setup
	econf "${myconf[@]}"
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
