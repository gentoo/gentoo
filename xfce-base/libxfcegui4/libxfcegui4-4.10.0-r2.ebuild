# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="A compability library for unported Xfce 4.6 plugins (DEPRECATED)"
HOMEPAGE="https://git.xfce.org/archive/libxfcegui4/"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="startup-notification"

RDEPEND="gnome-base/libglade
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfce4util-4.10
	startup-notification? ( x11-libs/startup-notification )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	eapply -p0 "${FILESDIR}"/${P}-no-xfce_setenv.patch
	default
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable startup-notification)
		# glade:3 no longer supported on Gentoo, #575166
		--disable-gladeui
		--with-html-dir="${EPREFIX}"/deprecated
		)
	econf "${myconf[@]}"
}

src_install() {
	default
	rm -rf "${ED}"/deprecated
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
