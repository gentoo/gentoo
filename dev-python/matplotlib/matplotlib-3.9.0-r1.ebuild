# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( pypy3 python3_{10..13} )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 pypi virtualx

FT_PV=2.6.1
DESCRIPTION="Pure python plotting library with matlab like syntax"
HOMEPAGE="
	https://matplotlib.org/
	https://github.com/matplotlib/matplotlib/
	https://pypi.org/project/matplotlib/
"
SRC_URI+="
	test? (
		https://downloads.sourceforge.net/project/freetype/freetype2/${FT_PV}/freetype-${FT_PV}.tar.gz
	)
"

# Main license: matplotlib
# Some modules: BSD
# matplotlib/backends/qt4_editor: MIT
# Fonts: BitstreamVera, OFL-1.1
LICENSE="BitstreamVera BSD matplotlib MIT OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"
IUSE="cairo excel gtk3 latex qt5 tk webagg wxwidgets"

DEPEND="
	media-libs/freetype:2
	>=media-libs/qhull-2013:=
	>=dev-python/numpy-1.25:=[${PYTHON_USEDEP}]
"
# internal copy of pycxx highly patched
#	dev-python/pycxx
RDEPEND="
	${DEPEND}
	>=dev-python/contourpy-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/cycler-0.10.0-r1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.22.0[${PYTHON_USEDEP}]
	>=dev-python/kiwisolver-1.3.1[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-8[jpeg,webp,${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	media-fonts/dejavu
	media-fonts/stix-fonts
	media-libs/libpng:0
	virtual/imagemagick-tools[jpeg,tiff]
	cairo? (
		dev-python/cairocffi[${PYTHON_USEDEP}]
	)
	excel? (
		dev-python/xlwt[${PYTHON_USEDEP}]
	)
	gtk3? (
		>=dev-python/pygobject-3.40.1-r1:3[cairo?,${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
	)
	latex? (
		virtual/latex-base
		app-text/dvipng
		app-text/ghostscript-gpl
		app-text/poppler[utils]
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		dev-texlive/texlive-xetex
	)
	qt5? (
		$(python_gen_cond_dep '
			dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
		' 'python3*')
	)
	webagg? (
		>=dev-python/tornado-6.0.4[${PYTHON_USEDEP}]
	)
	wxwidgets? (
		$(python_gen_cond_dep '
			dev-python/wxpython:*[${PYTHON_USEDEP}]
		' python3_{10..12})
	)
"

BDEPEND="
	${RDEPEND}
	dev-python/pybind11[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-7[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.0.4[${PYTHON_USEDEP}]
		!hppa? ( !s390? (
			|| (
				media-video/ffmpeg[openh264]
				media-video/ffmpeg[x264]
			)
		) )
		gtk3? (
			>=dev-python/pygobject-3.40.1-r1:3[cairo?,${PYTHON_USEDEP}]
			x11-libs/gtk+:3[introspection]
		)
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_unpack() {
	# do not unpack freetype
	unpack "${P}.tar.gz"
}

python_prepare_all() {
	# Affects installed _version.py, bug #854600
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

	local PATCHES=(
		"${FILESDIR}"/matplotlib-3.9.0-test.patch
	)

	# increase lock timeout to 30 s
	sed -i -e 's:retries = 50:retries = 300:' lib/matplotlib/cbook.py || die

	distutils-r1_python_prepare_all
}

src_configure() {
	unset DISPLAY # bug #278524
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	DISTUTILS_ARGS=(
		-Dsystem-freetype=true
		-Dsystem-qhull=true
		-Dmacosx=false
	)
}

src_test() {
	mkdir subprojects/packagecache || die
	cp "${DISTDIR}/freetype-${FT_PV}.tar.gz" subprojects/packagecache/ || die
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# broken by -Wdefault
		"tests/test_rcparams.py::test_validator_invalid[validate_strlist-arg6-MatplotlibDeprecationWarning]"
		"tests/test_rcparams.py::test_validator_invalid[validate_strlist-arg7-MatplotlibDeprecationWarning]"
		tests/test_testing.py::test_warn_to_fail
		tests/test_legend.py::test_legend_nolabels_warning
		# TODO?
		tests/test_backend_qt.py::test_fig_sigint_override
		tests/test_backend_qt.py::test_ipython
		tests/test_backend_nbagg.py::test_ipynb
		# leak tests are fragile
		tests/test_backends_interactive.py::test_figure_leak_20490
		# major "images not close", new texlive perhaps
		tests/test_contour.py::test_all_algorithms
		# "no warnings"
		tests/test_backend_pdf.py::test_invalid_metadata
		tests/test_figure.py::test_too_many_figures
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# TODO: warning isn't passed through
				tests/test_image.py::test_large_image
				# TODO
				tests/test_pickle.py::test_complete
				tests/test_pickle.py::test_no_pyplot
				tests/test_pickle.py::test_pickle_load_from_subprocess
				tests/test_pickle.py::test_simple
				tests/test_texmanager.py::test_openin_any_paranoid
				tests/test_widgets.py::test_check_buttons
				tests/test_widgets.py::test_check_buttons_lines
				tests/test_widgets.py::test_check_radio_buttons_image
				tests/test_widgets.py::test_radio_buttons
			)
			if has_version "<dev-python/pypy3_10-exe-7.3.13_p2" ||
				has_version "<dev-python/pypy3_10-exe-bin-7.3.13_p2"
			then
				EPYTEST_DESELECT+=(
					# TypeError is raised when exception is raised in a starred
					# expression referencing a generator that uses "yield from"
					# and raises -- non-critical, since some exception is raised
					# after all
					# https://foss.heptapod.net/pypy/pypy/-/issues/4032
					tests/test_axes.py::test_bad_plot_args
					tests/test_axes.py::test_plot_errors
					tests/test_axes.py::test_plot_format_errors
				)
			fi
			;;
		python3.11)
			EPYTEST_DESELECT+=(
				# https://github.com/matplotlib/matplotlib/issues/23384
				"tests/test_backends_interactive.py::test_figure_leak_20490[time_mem1-{'MPLBACKEND': 'qtagg', 'QT_API': 'PyQt5'}]"
				"tests/test_backends_interactive.py::test_figure_leak_20490[time_mem1-{'MPLBACKEND': 'qtcairo', 'QT_API': 'PyQt5'}]"
			)
			;;
		python3.12)
			EPYTEST_DESELECT+=(
				tests/test_constrainedlayout.py::test_compressed1
			)
			;;
	esac

	case ${ABI} in
		hppa)
			EPYTEST_DESELECT+=(
				'tests/test_mathtext.py::test_mathtext_exceptions[hspace without value]'
				'tests/test_mathtext.py::test_mathtext_exceptions[hspace with invalid value]'
				'tests/test_mathtext.py::test_mathtext_exceptions[function without space]'
				'tests/test_mathtext.py::test_mathtext_exceptions[accent without space]'
				'tests/test_mathtext.py::test_mathtext_exceptions[frac without parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[frac with empty parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[binom without parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[binom with empty parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[genfrac without parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[genfrac with empty parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[sqrt without parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[sqrt with invalid value]'
				'tests/test_mathtext.py::test_mathtext_exceptions[overline without parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[overline with empty parameter]'
				'tests/test_mathtext.py::test_mathtext_exceptions[left with invalid delimiter]'
				'tests/test_mathtext.py::test_mathtext_exceptions[right with invalid delimiter]'
				'tests/test_mathtext.py::test_mathtext_exceptions[unclosed parentheses with sizing]'
				'tests/test_mathtext.py::test_mathtext_exceptions[unclosed parentheses without sizing]'
				'tests/test_mathtext.py::test_mathtext_exceptions[dfrac without parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[dfrac with empty parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[overset without parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[underset without parameters]'
				'tests/test_mathtext.py::test_mathtext_exceptions[unknown symbol]'
				'tests/test_mathtext.py::test_mathtext_exceptions[double superscript]'
				'tests/test_mathtext.py::test_mathtext_exceptions[double subscript]'
				'tests/test_mathtext.py::test_mathtext_exceptions[super on sub without braces]'
				'tests/test_quiver.py::test_barbs[png]'
				'tests/test_quiver.py::test_barbs_pivot[png]'
				'tests/test_quiver.py::test_barbs_flip[png]'
				'tests/test_text.py::test_parse_math'
				'tests/test_text.py::test_parse_math_rcparams'
			)
			;&
		alpha|arm|m68k|o32|ppc|s390|sh|sparc|x86)
			EPYTEST_DESELECT+=(
				# too large for 32-bit platforms
				'tests/test_axes.py::test_psd_csd[png]'
			)
			;;
		*)
			;;
	esac

	# we need to rebuild mpl against bundled freetype, otherwise
	# over 1000 tests will fail because of mismatched font rendering
	local DISTUTILS_ARGS=(
		"${DISTUTILS_ARGS[@]}"
		-Dsystem-freetype=false
	)
	distutils_pep517_install "${BUILD_DIR}"/test
	cp -r "${BUILD_DIR}"/{install,test}"${EPREFIX}/usr/bin" || die
	local -x PATH=${BUILD_DIR}/test${EPREFIX}/usr/bin:${PATH}

	pushd lib >/dev/null || die
	local path
	local sitedir=${BUILD_DIR}/test$(python_get_sitedir)
	# sigh, upstream doesn't install these
	while IFS= read -d '' path; do
		cp -r "${path}" "${sitedir}/${path}" || die
	done < <(
		find \( \
				-name baseline_images -o \
				-name '*.ipynb' -o \
				-name '*.pfb' -o \
				-name '*.ttf' -o \
				-name tinypages \
			\) -print0
	)
	popd >/dev/null || die

	# speed tests up
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# pretend we're on CI to increase timeouts
	local -x CI=1
	nonfatal epytest --pyargs matplotlib -m "not network" \
		-p rerunfailures --reruns=3 \
		-o tmp_path_retention_policy=all || die
}
