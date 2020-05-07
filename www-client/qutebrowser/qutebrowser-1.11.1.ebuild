# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit desktop distutils-r1 eutils xdg-utils

DESCRIPTION="A keyboard-driven, vim-like browser based on PyQt5 and QtWebEngine"
HOMEPAGE="https://www.qutebrowser.org/ https://github.com/qutebrowser/qutebrowser"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scripts test"

BDEPEND="
	app-text/asciidoc"
RDEPEND="
	>=dev-python/attrs-19.3.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/cssutils-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.11.2[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/pypeg2-2.15.2[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.14.1[${PYTHON_USEDEP},declarative,multimedia,gui,network,opengl,printsupport,sql,widgets]
	>=dev-python/PyQtWebEngine-5.14.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP},libyaml]
"

distutils_enable_tests setup.py

# Tests restricted as the deplist (misc/requirements/requirements-tests.txt)
# isn't complete and X11 is required in order to start up qutebrowser.
RESTRICT="test"

python_compile_all() {
	a2x -f manpage doc/${PN}.1.asciidoc || die "Failed generating man page"
}

python_install_all() {
	doman doc/${PN}.1
	domenu misc/org.${PN}.${PN}.desktop
	doicon -s scalable icons/${PN}.svg

	if use scripts; then
		# Install only those userscripts that have an explicit license header
		exeinto /usr/share/qutebrowser/userscripts/
		doexe misc/userscripts/dmenu_qutebrowser
		doexe misc/userscripts/openfeeds
		doexe misc/userscripts/qute-keepass
		doexe misc/userscripts/qute-pass
		doexe misc/userscripts/rss
		doexe misc/userscripts/tor_identity
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "PDF display support" www-plugins/pdfjs
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
