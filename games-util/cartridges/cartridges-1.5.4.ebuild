# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit gnome2-utils meson python-single-r1 xdg

DESCRIPTION="Simple game launcher written in Python using GTK4 and Libadwaita"
HOMEPAGE="https://github.com/kra-mo/cartridges/"
SRC_URI="https://github.com/kra-mo/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	gui-libs/gtk:4[introspection]
	gui-libs/libadwaita:1[introspection]
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/blueprint-compiler
	dev-util/desktop-file-utils
"

PATCHES=( "${FILESDIR}"/${PN}-1.5.4-dont-validate-appstream.patch )

src_install() {
	meson_src_install

	python_fix_shebang "${ED}"/usr/bin
	python_optimize "${ED}"/usr/share/cartridges/cartridges
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
