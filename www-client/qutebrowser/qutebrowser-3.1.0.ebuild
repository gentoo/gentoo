# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/qutebrowser/qutebrowser.git"
else
	inherit verify-sig
	SRC_URI="
		https://github.com/qutebrowser/qutebrowser/releases/download/v${PV}/${P}.tar.gz
		verify-sig? ( https://github.com/qutebrowser/qutebrowser/releases/download/v${PV}/${P}.tar.gz.asc )
	"
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/qutebrowser.gpg
	KEYWORDS="amd64 ~arm64"
fi

DESCRIPTION="Keyboard-driven, vim-like browser based on Python and Qt"
HOMEPAGE="https://qutebrowser.org/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+adblock pdf +qt6 widevine"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/markupsafe[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/zipp[${PYTHON_USEDEP}]
		adblock? ( dev-python/adblock[${PYTHON_USEDEP}] )
		qt6? (
			dev-qt/qtbase:6[icu,sqlite]
			dev-python/PyQt6[${PYTHON_USEDEP},dbus,gui,network,opengl,printsupport,qml,sql,widgets]
			dev-python/PyQt6-WebEngine[${PYTHON_USEDEP},widgets]
			pdf? ( www-plugins/pdfjs )
		)
		!qt6? (
			dev-qt/qtcore:5[icu]
			dev-qt/qtgui:5[png]
			dev-qt/qtsql:5[sqlite]
			dev-python/PyQt5[${PYTHON_USEDEP},dbus,declarative,gui,network,opengl,printsupport,sql,widgets]
			dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
			pdf? ( <www-plugins/pdfjs-3 )
		)
		widevine? ( www-plugins/chrome-binary-plugins )
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		test? (
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
			qt6? ( dev-python/PyQt6[testlib] )
			!qt6? ( dev-python/PyQt5[testlib] )
		)
	')
"

if [[ ${PV} == 9999 ]]; then
	BDEPEND+=" app-text/asciidoc"
else
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-qutebrowser )"
fi

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	if use pdf; then
		# does not hurt to enable by default if it was explicitly requested
		sed -e '/^content.pdfjs:/,+1s/false/true/' \
			-i ${PN}/config/configdata.yml || die
	fi

	# ensure the requested backend is used in case multiple are available
	sed -e "/^_WRAPPER_OVERRIDE =/s/None/\"PyQt$(usex qt6 6 5)\"/" \
		-i qutebrowser/qt/machinery.py || die

	# let eclass handle python
	sed -i '/setup.py/d' misc/Makefile || die

	if [[ ${PV} == 9999 ]]; then
		# call asciidoc(1) rather than the single target python module
		sed -e '/cmdline = /s/= .*/= ["asciidoc"]/' \
			-i scripts/asciidoc2html.py || die

		"${EPYTHON}" scripts/asciidoc2html.py || die
	fi

	if use test; then
		# unnecessary here, and would require extra deps
		sed -e '/pytest-benchmark/d' -e 's/--benchmark[^ ]*//' \
			-e '/pytest-instafail/d' -e 's/--instafail//' \
			-i pytest.ini || die

		if [[ ${PV} == 9999 ]]; then
			# likewise, needs vulture
			rm tests/unit/scripts/test_run_vulture.py || die
		else
			# https://github.com/qutebrowser/qutebrowser/issues/7620
			rm tests/unit/scripts/test_problemmatchers.py || die
		fi
	fi
}

python_test() {
	local -x PYTEST_QT_API=pyqt$(usex qt6 6 5)

	local EPYTEST_DESELECT=(
		# end2end/IPC tests are broken with "Name error" if socket path is over
		# ~108 characters (>124 in /var/tmp/portage) due to Linux limitations,
		# skip rather than bother using /tmp+cleanup over ${T} (end2end tests
		# are important, but the other tests should be enough for downstream)
		tests/end2end
		tests/unit/misc/test_ipc.py
		# python eclasses provide a fake "failing" python2 and trips this test
		tests/unit/misc/test_checkpyver.py::test_old_python
		# not worth running dbus over
		tests/unit/browser/test_notification.py::TestDBus
		# fails in ebuild, seems due to saving fake downloads in the wrong location
		tests/unit/browser/webengine/test_webenginedownloads.py::TestDataUrlWorkaround
		# may fail if environment is very large (bug #819393)
		tests/unit/commands/test_userscripts.py::test_custom_env\[_POSIXUserscriptRunner\]
		# needs _WRAPPER_OVERRIDE = None, but we have changed it
		tests/unit/test_qt_machinery.py::TestSelectWrapper::test_autoselect_by_default
		tests/unit/test_qt_machinery.py::TestInit::test_none_available_{implicit,explicit}
		# fails if chromium version is unrecognized (aka newer qtwebengine)
		tests/unit/utils/test_version.py::TestWebEngineVersions::test_real_chromium_version
	)

	# tests known failing with Qt5 which is considered a 2nd class citizen
	# and, unless completely broken, new tests issues may not be pursued
	use qt6 || EPYTEST_DESELECT+=(
		tests/unit/mainwindow/test_tabwidget.py::TestTabWidget::test_tab_text_not_edlided_for_wide_tabs
	)

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

	if [[ ! -v QUTEBROWSER_HAD_QT6 && ${REPLACING_VERSIONS} ]] && use qt6; then
		ewarn
		ewarn "Be warned that starting the Qt6 version of ${PN} performs a one-way"
		ewarn "conversion of ~/.local/share/${PN}/webengine to Qt6. There will also"
		ewarn "be a warning on startup, and may optionally want to backup first."
	fi

	# only show Qt6 warning on arches where USE=qt6 is unmasked
	if use amd64 && use !qt6; then
		ewarn
		ewarn "USE=qt6 is disabled, be warned that Qt5's WebEngine uses an older"
		ewarn "chromium version. While it is relatively maintained for security, it will"
		ewarn "cause issues for sites/features designed with a newer version in mind."
	fi
}
