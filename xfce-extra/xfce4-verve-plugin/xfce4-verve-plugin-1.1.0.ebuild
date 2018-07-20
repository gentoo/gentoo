# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit multilib xfconf

DESCRIPTION="A comfortable command line plugin for the Xfce panel"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-verve-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="dbus"

RDEPEND=">=xfce-base/exo-0.6:=
	>=xfce-base/libxfce4util-4.8:=
	>=xfce-base/libxfcegui4-4.8:=
	>=xfce-base/xfce4-panel-4.8:=
	dev-libs/glib:2=
	>=dev-libs/libpcre-5:=
	dbus? ( >=dev-libs/dbus-glib-0.98:= )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable dbus)
		)

	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
