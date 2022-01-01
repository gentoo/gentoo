# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit desktop distutils-r1 optfeature xdg-utils

DESCRIPTION="A keyboard-driven, vim-like browser based on PyQt5 and QtWebEngine"
HOMEPAGE="https://www.qutebrowser.org/ https://github.com/qutebrowser/qutebrowser"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="scripts test"

BDEPEND="
	app-text/asciidoc"
RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/cssutils[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.7.2[${PYTHON_USEDEP}]
	dev-python/pypeg2[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},declarative,multimedia,gui,network,opengl,printsupport,sql,widgets]
	dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
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
		insinto /usr/share/qutebrowser/userscripts/
		doins misc/userscripts/README.md
		exeinto /usr/share/qutebrowser/userscripts/
		doexe misc/userscripts/cast \
		      misc/userscripts/dmenu_qutebrowser \
		      misc/userscripts/format_json \
		      misc/userscripts/getbib \
		      misc/userscripts/open_download \
		      misc/userscripts/openfeeds \
		      misc/userscripts/password_fill \
		      misc/userscripts/qute-bitwarden \
		      misc/userscripts/qutedmenu \
		      misc/userscripts/qute-keepass \
		      misc/userscripts/qute-lastpass \
		      misc/userscripts/qute-pass \
		      misc/userscripts/readability \
		      misc/userscripts/readability-js \
		      misc/userscripts/ripbang \
		      misc/userscripts/rss \
		      misc/userscripts/taskadd \
		      misc/userscripts/tor_identity \
		      misc/userscripts/view_in_mpv
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
