# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit desktop distutils-r1 git-r3 optfeature xdg

DESCRIPTION="Keyboard-driven, vim-like browser based on PyQt5 and QtWebEngine"
HOMEPAGE="https://www.qutebrowser.org/ https://github.com/qutebrowser/qutebrowser"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-3+"
SLOT="0"
IUSE="scripts test"

BDEPEND="
	app-text/asciidoc"
RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/cssutils[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/importlib_resources[${PYTHON_USEDEP}]' python3_8)
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pypeg2[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},dbus,declarative,multimedia,gui,network,opengl,printsupport,sql,widgets]
	dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP},libyaml(+)]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/zipp[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py

# Tests restricted as the deplist (misc/requirements/requirements-tests.txt)
# isn't complete and X11 is required in order to start up qutebrowser.
RESTRICT="test"

python_compile() {
	${EPYTHON} scripts/asciidoc2html.py || die
	distutils-r1_python_compile
}

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
		doexe misc/userscripts/add-nextcloud-bookmarks \
		      misc/userscripts/add-nextcloud-cookbook \
		      misc/userscripts/cast \
		      misc/userscripts/dmenu_qutebrowser \
		      misc/userscripts/format_json \
		      misc/userscripts/getbib \
		      misc/userscripts/kodi \
		      misc/userscripts/open_download \
		      misc/userscripts/openfeeds \
		      misc/userscripts/password_fill \
		      misc/userscripts/qr \
		      misc/userscripts/qute-bitwarden \
		      misc/userscripts/qutedmenu \
		      misc/userscripts/qute-keepass \
		      misc/userscripts/qute-keepassxc \
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
	xdg_pkg_postinst

	optfeature "PDF display support" www-plugins/pdfjs
}
