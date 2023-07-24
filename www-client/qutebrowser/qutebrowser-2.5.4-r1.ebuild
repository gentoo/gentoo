# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/qutebrowser/qutebrowser.git"
else
	SRC_URI="https://github.com/qutebrowser/qutebrowser/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~x86"
fi

DESCRIPTION="Keyboard-driven, vim-like browser based on Python and Qt"
HOMEPAGE="https://www.qutebrowser.org/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+adblock pdf widevine"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/PyQt5[${PYTHON_USEDEP},dbus,declarative,gui,network,opengl,printsupport,sql,widgets]
		dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.1.1[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/zipp[${PYTHON_USEDEP}]
		adblock? ( dev-python/adblock[${PYTHON_USEDEP}] )
	')
	dev-qt/qtcore:5[icu]
	dev-qt/qtgui:5[png]
	dev-qt/qtsql:5[sqlite]
	pdf? ( <www-plugins/pdfjs-3 )
	widevine? ( www-plugins/chrome-binary-plugins )"
BDEPEND="
	$(python_gen_cond_dep '
		test? (
			dev-python/PyQt5[testlib]
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			dev-python/cheroot[${PYTHON_USEDEP}]
			dev-python/flask[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/pytest-bdd[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/pytest-qt[${PYTHON_USEDEP}]
			dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
			dev-python/pytest-xvfb[${PYTHON_USEDEP}]
			dev-python/tldextract[${PYTHON_USEDEP}]
		)
	')"
[[ ${PV} == 9999 ]] && BDEPEND+=" app-text/asciidoc"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-tests-python-3.11.4.patch
)

src_prepare() {
	distutils-r1_src_prepare

	if use pdf; then
		sed -e '/^content.pdfjs:/,+1s/false/true/' \
			-i ${PN}/config/configdata.yml || die
	fi

	if use widevine && use prefix; then
		# hack: QtWebEngine knows Gentoo's widevine, but not with ${EPREFIX}
		local widevine=${EPREFIX}/usr/$(get_libdir)/chromium-browser/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
		sed -e "/yield from _qtwebengine_settings_args/a\    yield '--widevine-path=${widevine}'" \
			-i ${PN}/config/qtargs.py || die
	fi

	# let eclass handle python
	sed -i '/setup.py/d' misc/Makefile || die

	if [[ ${PV} == 9999 ]]; then
		# call asciidoc(1) rather than the single target python module
		sed -e '/cmdline = /s/= .*/= ["asciidoc"]/' \
			-i scripts/asciidoc2html.py || die

		"${EPYTHON}" scripts/asciidoc2html.py || die
	fi

	# disable unnecessary tests/plugins that need extras
	sed -e '/pytest-benchmark/d' -e 's/--benchmark[^ ]*//' \
		-e '/pytest-instafail/d' -e 's/--instafail//' \
		-i pytest.ini || die
	if [[ ${PV} == 9999 ]]; then
		rm tests/unit/scripts/test_run_vulture.py || die
	else
		rm tests/unit/scripts/test_problemmatchers.py || die
	fi
}

python_test() {
	local -x PYTEST_QT_API=pyqt5

	local EPYTEST_DESELECT=(
		# end2end and other IPC tests are broken with "Name error" if
		# socket path is over ~104 characters (=124 in /var/tmp/portage)
		# https://github.com/qutebrowser/qutebrowser/issues/888 (not just OSX)
		tests/end2end
		tests/unit/misc/test_ipc.py
		# calls eclass' python2 "failure" wrapper
		tests/unit/misc/test_checkpyver.py::test_old_python
		# not worth running dbus over
		tests/unit/browser/test_notification.py::TestDBus
		# bug 819393
		tests/unit/commands/test_userscripts.py::test_custom_env[_POSIXUserscriptRunner]
		# tests that don't know about our newer qtwebengine:5
		tests/unit/browser/webengine/test_webenginedownloads.py::TestDataUrlWorkaround
	)
	# qtargs are mangled with widevine+prefix
	use widevine && use prefix && EPYTEST_DESELECT+=( tests/unit/config/test_qtargs.py )

	# skip benchmarks (incl. _tree), and warning tests broken by -Wdefault
	epytest -p xvfb -k 'not _bench and not _matches_tree and not _warning'
}

python_install_all() {
	emake -f misc/Makefile DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install

	rm "${ED}"/usr/share/${PN}/scripts/{mkvenv,utils}.py || die
	fperms -x /usr/share/${PN}/{scripts/cycle-inputs.js,userscripts/README.md}
	python_fix_shebang "${ED}"/usr/share/${PN}

	einstalldocs
}

pkg_preinst() {
	xdg_pkg_preinst

	has_version "${CATEGORY}/${PN}[qt6]" && QUTEBROWSER_HAD_QT6=
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that optional scripts in ${EROOT}/usr/share/${PN}/{user,}scripts"
		elog "have additional dependencies not covered by this ebuild, for example"
		elog "view_in_mpv needs media-video/mpv[lua] and net-misc/yt-dlp."
	fi

	if [[ -v QUTEBROWSER_HAD_QT6 ]]; then
		ewarn "This is a downgrade from Qt6-based ${PN} to Qt5-based, and this"
		ewarn "older version of ${PN} will /not/ warn on startup that this is"
		ewarn "going to destroy some browsing data (e.g. cookies) when older chromium"
		ewarn "version tries to use the newer ~/.local/share/${PN}/webengine."
		ewarn
		ewarn "It is recommended to backup in case or go back to Qt6."
	fi
}
