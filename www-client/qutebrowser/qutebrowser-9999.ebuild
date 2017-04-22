# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit gnome2-utils distutils-r1 eutils fdo-mime

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/The-Compiler/qutebrowser.git"
	inherit git-r3
else
	SRC_URI="https://github.com/The-Compiler/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A keyboard-driven, vim-like browser based on PyQt5 and QtWebKit"
HOMEPAGE="http://www.qutebrowser.org/ https://github.com/The-Compiler/qutebrowser"

LICENSE="GPL-3"
SLOT="0"
IUSE="gstreamer test"

COMMON_DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="${COMMON_DEPEND}
	>=dev-python/cssutils-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.1.3[${PYTHON_USEDEP}]
	>=dev-python/pypeg2-2.15.2[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},declarative,gui,network,printsupport,webkit,widgets]
	dev-python/sip[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
	gstreamer? ( dev-qt/qtwebkit:5[gstreamer] )
"

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
	dodoc {CHANGELOG,CONTRIBUTING,FAQ,README}.asciidoc

	domenu ${PN}.desktop
	doicon -s scalable icons/${PN}.svg

	distutils-r1_python_install_all
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	optfeature "PDF display support" www-plugins/pdfjs
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
