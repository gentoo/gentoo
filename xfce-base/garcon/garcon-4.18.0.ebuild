# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Xfce's freedesktop.org specification compatible menu implementation library"
HOMEPAGE="
	https://docs.xfce.org/xfce/garcon/start
	https://gitlab.xfce.org/xfce/garcon/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="introspection"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/libxfce4util-4.15.6:=[introspection?]
	>=xfce-base/libxfce4ui-4.15.7:=[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.66:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/glib-utils
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	introspection? ( >=dev-libs/gobject-introspection-1.66 )
"

src_configure() {
	local myconf=(
		$(use_enable introspection)
	)

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
