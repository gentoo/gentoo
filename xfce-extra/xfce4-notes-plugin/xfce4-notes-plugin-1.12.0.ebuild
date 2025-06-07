# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala xdg-utils

DESCRIPTION="Xfce4 panel sticky notes plugin"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-notes-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-notes-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/$(ver_cut 1-2)/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 arm ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.50.0:2
	>=x11-libs/gtk+-3.22.0:3
	>=x11-libs/gtksourceview-4.0.0:4[introspection,vala]
	>=xfce-base/libxfce4ui-4.16.0:=[introspection,vala]
	>=xfce-base/libxfce4util-4.16.0:=[introspection,vala]
	>=xfce-base/xfce4-panel-4.16.0:=[introspection,vala]
	>=xfce-base/xfconf-4.16.0:=[introspection,vala]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	$(vala_depend)
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	vala_setup
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
