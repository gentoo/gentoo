# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit meson python-single-r1 xdg-utils

DESCRIPTION="A frontend for find, (s)locate, doodle, tracker, beagle, strigi and pinot"
HOMEPAGE="
	https://docs.xfce.org/apps/catfish/start
	https://gitlab.xfce.org/apps/catfish/
"
SRC_URI="
	https://archive.xfce.org/src/apps/catfish/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.50.0
	dev-libs/gobject-introspection
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	>=x11-libs/gdk-pixbuf-2.42.8[introspection]
	>=x11-libs/gtk+-3.22.0:3[introspection]
	>=x11-libs/pango-1.38.0[introspection]
	>=xfce-base/xfconf-4.16.0[introspection]
	virtual/freedesktop-icon-theme
"
BDEPEND="
	sys-devel/gettext
"

src_prepare() {
	default
	python_fix_shebang bin/catfish
}

src_install() {
	meson_src_install
	# stupid meson
	rm -r "${ED}/usr/share/doc/catfish" || die
	python_optimize
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
