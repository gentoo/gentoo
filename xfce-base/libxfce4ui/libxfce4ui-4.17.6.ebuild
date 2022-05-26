# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils vala

DESCRIPTION="Unified widget and session management libs for Xfce"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug glade +introspection startup-notification system-info vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.50:2
	>=x11-libs/gtk+-3.22:3[introspection?,X]
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM
	>=xfce-base/libxfce4util-4.15.6:=[introspection?]
	>=xfce-base/xfconf-4.12:=
	glade? ( dev-util/glade:3.10 )
	introspection? ( dev-libs/gobject-introspection:= )
	startup-notification? ( x11-libs/startup-notification )
	system-info? (
		dev-libs/libgudev
		gnome-base/libgtop
		>=media-libs/libepoxy-1.2
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable system-info glibtop)
		$(use_enable system-info epoxy)
		$(use_enable system-info gudev)
		$(use_enable startup-notification)
		$(use_enable vala)
		$(use_enable glade gladeui2)
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
