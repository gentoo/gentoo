# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit meson python-single-r1 xdg-utils

DESCRIPTION="Simple application to manage Xfce panel layouts"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-panel-profiles/start
	https://gitlab.xfce.org/apps/xfce4-panel-profiles/
"
SRC_URI="
	https://archive.xfce.org/src/apps/xfce4-panel-profiles/$(ver_cut 1-2)/${P}.tar.xz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	${BDEPEND}
	>=dev-libs/glib-2.50.0
	dev-libs/gobject-introspection
	$(python_gen_cond_dep '
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	>=x11-libs/gtk+-3.22.0:3[introspection]
	>=xfce-base/libxfce4ui-4.16.0[introspection]
	>=xfce-base/libxfce4util-4.16.0[introspection]
	>=xfce-base/xfce4-panel-4.16.0
"

src_prepare() {
	default

	# meaningless docs
	sed -i -e '/COPYING/d' -e '/INSTALL/d' meson.build || die
}

src_configure() {
	local emesonargs=(
		# used in installed script
		-Dpython-path="${EPYTHON}"
		-Dcheck-runtime-dependencies=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
