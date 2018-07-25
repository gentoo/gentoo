# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )

inherit distutils-r1 eutils gnome2-utils xdg-utils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A keyboard-driven, vim-like browser based on PyQt5 and QtWebEngine"
HOMEPAGE="https://www.qutebrowser.org/ https://github.com/qutebrowser/qutebrowser"

LICENSE="GPL-3"
SLOT="0"
IUSE="test"

COMMON_DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="${COMMON_DEPEND}
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.1.3[${PYTHON_USEDEP}]
	>=dev-python/pypeg2-2.15.2[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.7.1[${PYTHON_USEDEP},declarative,gui,network,opengl,printsupport,sql,webengine,widgets]
	>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
"

# Tests restricted as the deplist (misc/requirements/requirements-tests.txt)
# isn't complete and X11 is required in order to start up qutebrowser.
RESTRICT="test"

python_compile_all() {
	if [[ ${PV} == "9999" ]]; then
		"${PYTHON}" scripts/asciidoc2html.py || die "Failed generating docs"
	fi

	a2x -f manpage doc/${PN}.1.asciidoc || die "Failed generating man page"
}

python_test() {
	py.test tests || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	doman doc/${PN}.1
	domenu misc/${PN}.desktop
	doicon -s scalable icons/${PN}.svg

	distutils-r1_python_install_all
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	optfeature "PDF display support" www-plugins/pdfjs
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
