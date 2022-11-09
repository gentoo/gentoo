# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 multiprocessing xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/qutebrowser/qutebrowser.git"
	EGIT_BRANCH="qt6-v2"
else
	SRC_URI="https://github.com/qutebrowser/qutebrowser/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Keyboard-driven, vim-like browser based on Python and Qt"
HOMEPAGE="https://www.qutebrowser.org/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+adblock pdf +qt6 widevine"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/importlib_resources[${PYTHON_USEDEP}]' 3.8)
	$(python_gen_cond_dep '
		dev-python/colorama[${PYTHON_USEDEP}]
		>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.1.1[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6[${PYTHON_USEDEP}]
		dev-python/zipp[${PYTHON_USEDEP}]
		adblock? ( dev-python/adblock[${PYTHON_USEDEP}] )')
	qt6? (
		dev-qt/qtbase:6[icu]
		$(python_gen_cond_dep '
			dev-python/PyQt6[${PYTHON_USEDEP},dbus,gui,network,opengl,printsupport,qml,sql,widgets]
			dev-python/PyQt6-WebEngine[${PYTHON_USEDEP},widgets]')
		pdf? ( www-plugins/pdfjs )
	)
	!qt6? (
		dev-qt/qtcore:5[icu]
		dev-qt/qtgui:5[png]
		$(python_gen_cond_dep '
			dev-python/PyQt5[${PYTHON_USEDEP},dbus,declarative,gui,network,opengl,printsupport,sql,widgets]
			dev-python/PyQtWebEngine[${PYTHON_USEDEP}]')
		pdf? ( <www-plugins/pdfjs-3 )
	)
	widevine? ( www-plugins/chrome-binary-plugins )"
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
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/pytest-xvfb[${PYTHON_USEDEP}]
			dev-python/tldextract[${PYTHON_USEDEP}]
			qt6? ( dev-python/PyQt6[testlib] )
			!qt6? ( dev-python/PyQt5[testlib] )
		)')"
[[ ${PV} == *9999 ]] && BDEPEND+=" app-text/asciidoc"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	if use pdf; then
		sed '/^content.pdfjs:/,+1s/false/true/' \
			-i ${PN}/config/configdata.yml || die
	fi

	if use widevine; then
		# Qt6 knows Gentoo's, but pass to ensure libdir, EPREFIX, and for Qt5
		local widevine=${EPREFIX}/usr/$(get_libdir)/chromium-browser/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
		sed "/yield from _qtwebengine_settings_args/a\    yield '--widevine-path=${widevine}'" \
			-i ${PN}/config/qtargs.py || die
	fi

	# ensure run the requested Qt backend
	sed -i '/^_WRAPPERS = /,/^]/c\_WRAPPERS = [ "PyQt'$(usex qt6 6 5)'" ]' \
		${PN}/qt/machinery.py || die

	# let eclass handle python
	sed -i '/setup.py/d' misc/Makefile || die

	# live version lacks pre-generated docs
	[[ ${PV} != *9999 ]] || ${EPYTHON} scripts/asciidoc2html.py || die

	# disable unnecessary tests/plugins that need extras (_ignore not enough)
	sed -e '/pytest-benchmark/d' -e 's/--benchmark[^ ]*//' \
		-e '/pytest-instafail/d' -e 's/--instafail//' \
		-i pytest.ini || die
	if [[ ${PV} == *9999 ]]; then
		rm tests/unit/scripts/test_run_vulture.py || die
	else
		rm tests/unit/scripts/test_problemmatchers.py || die
	fi
}

python_test() {
	local -x PYTEST_QT_API=pyqt$(usex qt6 6 5)

	local EPYTEST_DESELECT=(
		# end2end and other IPC tests are broken with "Name error" if
		# socket path is over ~104 characters (=124 in /var/tmp/portage)
		# https://github.com/qutebrowser/qutebrowser/issues/888 (not just OSX)
		tests/end2end
		tests/unit/misc/test_ipc.py
		# not worth running dbus over
		tests/unit/browser/test_notification.py::TestDBus
		# bug 819393
		tests/unit/commands/test_userscripts.py::test_custom_env[_POSIXUserscriptRunner]
		# calls eclass' python2 "failure" wrapper
		tests/unit/misc/test_checkpyver.py::test_old_python
		# qtargs are mangled with USE=widevine
		$(usev widevine tests/unit/config/test_qtargs.py)
	)

	# single thread is slow, but do half+1 given spikes ram usage quickly
	local jobs=$(($(makeopts_jobs) / 2 + 1))

	# skip benchmarks (incl. _tree), and warning tests broken by -Wdefault
	epytest -p xvfb -n ${jobs} -k 'not _bench and not _matches_tree and not _warning'
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

	if [[ ! -v QUTEBROWSER_HAD_QT6 ]] && use qt6; then
		elog "USE=qt6 is enabled using the qt6-v2 branch, it is work-in-progress"
		elog "and some issues may be expected. Can follow upstream progress at:"
		elog "  https://github.com/qutebrowser/qutebrowser/issues/7202 [qt6 general]"
		elog "  https://github.com/qutebrowser/qutebrowser/tree/qt6-v2 [used branch]"
		if [[ ${REPLACING_VERSIONS} ]]; then
			elog
			elog "You may optionally want to backup your ~/.local/share/${PN} before"
			elog "it is converted to use Qt6 WebEngine (one-way conversion). ${PN}"
			elog "will also warn about this on launch for a last chance to abort."
		fi
	fi

	# TODO: left-out given be confusing while IUSE is masked anywhere
#	if use !qt6; then
#		ewarn "USE=qt6 is disabled, be warned that Qt5's WebEngine uses an older"
#		ewarn "chromium version. While it is relatively maintained for security, it may"
#		ewarn "cause issues for sites/features designed with a newer version in mind."
#	fi
}
