# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils vala

DESCRIPTION="Unified widget and session management libs for Xfce"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug glade +gtk2 introspection startup-notification vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!gtk2? ( test )"

RDEPEND=">=dev-libs/glib-2.42:2=
	>=x11-libs/gtk+-3.18:3=[introspection?]
	x11-libs/libX11:=
	x11-libs/libICE:=
	x11-libs/libSM:=
	>=xfce-base/libxfce4util-4.12:=[introspection?]
	>=xfce-base/xfconf-4.12:=
	glade? ( dev-util/glade:3.10= )
	gtk2? ( >=x11-libs/gtk+-2.24:2= )
	introspection? ( dev-libs/gobject-introspection:= )
	startup-notification? ( x11-libs/startup-notification:= )
	!xfce-base/xfce-utils"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )"

src_prepare() {
	# stupid vala.eclass...
	default
}

src_configure() {
	local myconf=(
		$(use_enable gtk2)
		$(use_enable introspection)
		$(use_enable startup-notification)
		$(use_enable vala)
		# requires deprecated glade:3 (gladeui-1.0), bug #551296
		--disable-gladeui
		# this one's for :3.10
		$(use_enable glade gladeui2)
		--with-vendor-info=Gentoo
	)

	use vala && vala_src_prepare
	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
