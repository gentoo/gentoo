# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit gnome2-utils python-single-r1 meson ninja-utils xdg

DESCRIPTION="Simple game launcher written in Python using GTK4 and Libadwaita"
HOMEPAGE="https://github.com/kra-mo/cartridges/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/kra-mo/${PN}"
else
	SRC_URI="https://github.com/kra-mo/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"             # Just appstream file validation that uses network.
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=gui-libs/gtk-4.16.12:4[introspection]
	>=gui-libs/libadwaita-1.6.2:1[introspection]
	media-libs/tiff[webp]
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
	dev-libs/appstream-glib
	dev-util/blueprint-compiler
	dev-util/desktop-file-utils
"

src_compile() {
	cd "${BUILD_DIR}" || die

	eninja data/page.kramo.Cartridges.metainfo.xml
	meson_src_compile
}

src_install() {
	meson_src_install

	python_fix_shebang "${ED}/usr/bin"
	python_optimize "${ED}/usr"
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
