# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="System load plug-in for Xfce panel"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-systemload-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="upower"

RDEPEND=">=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/xfce4-panel-4.12:=
	>=xfce-base/xfconf-4.14:=
	upower? ( >=sys-power/upower-0.9.23 )"
DEPEND=${RDEPEND}
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable upower)
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
