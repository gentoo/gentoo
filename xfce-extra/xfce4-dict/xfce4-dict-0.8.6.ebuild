# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A dict.org querying application and panel plug-in for the Xfce desktop"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-dict/start
	https://gitlab.xfce.org/apps/xfce4-dict/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.24.0
	>=x11-libs/gtk+-3.22.0:3
	x11-libs/libX11
	>=xfce-base/libxfce4util-4.10.0:=
	>=xfce-base/libxfce4ui-4.12.0:=
	>=xfce-base/xfce4-panel-4.10.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/intltool
	virtual/pkgconfig
"

src_configure() {
	econf --libexecdir="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
