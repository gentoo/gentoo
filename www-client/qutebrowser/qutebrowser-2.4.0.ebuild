# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/qutebrowser/qutebrowser.git"
else
	SRC_URI="https://github.com/qutebrowser/qutebrowser/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~x86"
fi

DESCRIPTION="Keyboard-driven, vim-like browser based on PyQt5 and QtWebEngine"
HOMEPAGE="https://www.qutebrowser.org/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+adblock widevine"

RDEPEND="
	dev-qt/qtcore:5[icu]
	dev-qt/qtgui:5[png]
	$(python_gen_cond_dep 'dev-python/importlib_resources[${PYTHON_USEDEP}]' python3_8)
	$(python_gen_cond_dep '
		>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
		>=dev-python/jinja-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP},dbus,declarative,multimedia,gui,network,opengl,printsupport,sql,widgets]
		dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP},libyaml(+)]
		>=dev-python/typing-extensions-3.10.0.2[${PYTHON_USEDEP}]
		>=dev-python/zipp-3.6.0[${PYTHON_USEDEP}]
		adblock? ( >=dev-python/adblock-0.5.0[${PYTHON_USEDEP}] )
	')
	widevine? ( www-plugins/chrome-binary-plugins )"
BDEPEND="
	app-text/asciidoc
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
		)
	')"

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	if use widevine; then
		sed "/yield from _qtwebengine_settings_args/a\    yield '--widevine-path=${EPREFIX}/usr/$(get_libdir)/chromium-browser/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so'" \
			-i ${PN}/config/qtargs.py || die
	fi

	sed -i '/setup.py/d' misc/Makefile || die

	[[ ${PV} != 9999 ]] || ${EPYTHON} scripts/asciidoc2html.py || die

	# these plugins/tests are unnecessary here and have extra dependencies
	sed -e '/pytest-benchmark/d;s/--benchmark[^ ]*//' \
		-e '/pytest-instafail/d;s/--instafail//' \
		-i pytest.ini || die
	[[ ${PV} == 9999 ]] || rm tests/unit/scripts/test_problemmatchers.py || die
	[[ ${PV} != 9999 ]] || rm tests/unit/scripts/test_run_vulture.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# end2end and other IPC tests are broken with "Name error" if
		# socket path is over 104 characters (=124 in /var/tmp/portage)
		# https://github.com/qutebrowser/qutebrowser/issues/888 (not just OSX)
		tests/end2end
		tests/unit/misc/test_ipc.py
		# tests that don't know about our newer qtwebengine
		tests/unit/browser/webengine/test_webenginedownloads.py::TestDataUrlWorkaround
		tests/unit/utils/test_version.py::TestChromiumVersion
		# needs qtwebkit and isn't skipped by default
		tests/unit/config/test_websettings.py::test_config_init
		# may misbehave depending on installed old python versions
		tests/unit/misc/test_checkpyver.py::test_old_python
		# bug 819393
		tests/unit/commands/test_userscripts.py::test_custom_env[_POSIXUserscriptRunner]
	)
	use widevine && EPYTEST_DESELECT+=( tests/unit/config/test_qtargs.py )

	# skip benchmarks (incl. _tree), and warning tests broken by -Wdefault
	epytest -k 'not _bench and not _matches_tree and not _warning'
}

python_install_all() {
	emake -f misc/Makefile DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	rm "${ED}"/usr/share/${PN}/scripts/{mkvenv,utils}.py || die
	fperms -x /usr/share/${PN}/{scripts/cycle-inputs.js,userscripts/README.md}
	python_fix_shebang "${ED}"/usr/share/${PN}

	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "PDF display support" www-plugins/pdfjs

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that optional scripts in ${EROOT}/usr/share/${PN}/{user,}scripts"
		elog "have additional dependencies not covered by this ebuild, for example"
		elog "view_in_mpv needs media-video/mpv[lua] and net-misc/yt-dlp."
	fi
}
