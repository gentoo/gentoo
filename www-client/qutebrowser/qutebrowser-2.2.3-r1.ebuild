# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit desktop distutils-r1 optfeature xdg-utils

DESCRIPTION="A keyboard-driven, vim-like browser based on PyQt5 and QtWebEngine"
HOMEPAGE="https://www.qutebrowser.org/ https://github.com/qutebrowser/qutebrowser"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+adblock test"

BDEPEND="app-text/asciidoc"
RDEPEND="dev-python/colorama[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/importlib_resources[${PYTHON_USEDEP}]' python3_{7,8})
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},dbus,declarative,multimedia,gui,network,opengl,printsupport,sql,widgets]
	dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP},libyaml]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/zipp[${PYTHON_USEDEP}]
	adblock? ( dev-python/adblock[${PYTHON_USEDEP}] )"

distutils_enable_tests setup.py

# Tests restricted as the deplist (misc/requirements/requirements-tests.txt)
# isn't complete and X11 is required in order to start up qutebrowser.
RESTRICT="test"

python_compile_all() {
	a2x -f manpage doc/${PN}.1.asciidoc || die "Failed generating man page"
}

python_install_all() {
	insinto /usr/share/metainfo
	doins misc/org.qutebrowser.qutebrowser.appdata.xml
	doman doc/${PN}.1
	domenu misc/org.${PN}.${PN}.desktop
	for s in 16 24 32 48 64 128 256 512; do
		doicon -s ${s} icons/qutebrowser-${s}x${s}.png
	done
	doicon -s scalable icons/${PN}.svg

	insinto /usr/share/qutebrowser/userscripts
	doins misc/userscripts/README.md
	exeinto /usr/share/qutebrowser/userscripts
	for f in misc/userscripts/*; do
		if [[ "${f}" == "__pycache__" ]]; then
			continue
		fi
		doexe "${f}"
	done

	exeinto /usr/share/qutebrowser/scripts
	for f in scripts/*; do
		if [[ "${f}" == "scripts/__init__.py" || \
		      "${f}" == "scripts/__pycache__" || \
		      "${f}" == "scripts/dev" || \
		      "${f}" == "scripts/testbrowser" || \
		      "${f}" == "scripts/asciidoc2html.py" || \
		      "${f}" == "scripts/setupcommon.py" || \
		      "${f}" == "scripts/link_pyqt.py" ]]; then
			continue
		fi
		doexe "${f}"
	done

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
