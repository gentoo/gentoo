# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit python-single-r1 xdg-utils

DESCRIPTION="Simple application to manage Xfce panel layouts"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-panel-profiles/start
	https://gitlab.xfce.org/apps/xfce4-panel-profiles/
"
SRC_URI="
	https://archive.xfce.org/src/apps/xfce4-panel-profiles/$(ver_cut 1-2)/${P}.tar.bz2
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	${BDEPEND}
	dev-libs/gobject-introspection
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3[introspection]
	xfce-base/libxfce4ui[introspection]
	xfce-base/xfce4-panel
"

src_configure() {
	# home-made configure script, yay!
	./configure \
		--prefix="${EPREFIX}/usr" \
		--python="${EPYTHON}" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
