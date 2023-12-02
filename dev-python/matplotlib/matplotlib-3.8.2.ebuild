# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 flag-o-matic prefix pypi toolchain-funcs virtualx

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
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="cairo doc excel gtk3 latex qt5 tk webagg wxwidgets"

# internal copy of pycxx highly patched
#	dev-python/pycxx
RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/contourpy-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/cycler-0.10.0-r1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.22.0[${PYTHON_USEDEP}]
	>=dev-python/kiwisolver-1.3.1[${PYTHON_USEDEP}]
	<dev-python/numpy-2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.25[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-8[jpeg,webp,${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	media-fonts/dejavu
	media-fonts/stix-fonts
	media-libs/freetype:2
	media-libs/libpng:0
	>=media-libs/qhull-2013:=
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
		' python3_{10..11})
	)
"

BDEPEND="
	${RDEPEND}
	dev-python/pybind11[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-7[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		>=app-text/dvipng-1.15-r1
		>=dev-python/colorspacious-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/ipython-1.18.2[${PYTHON_USEDEP}]
		>=dev-python/numpydoc-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-gallery-0.3.1-r1[${PYTHON_USEDEP}]
		>=dev-python/xlwt-1.3.0-r1[${PYTHON_USEDEP}]
		virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-luatex
		dev-texlive/texlive-xetex
		>=media-gfx/graphviz-2.42.3[cairo]
	)
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.0.4[${PYTHON_USEDEP}]
		gtk3? (
			>=dev-python/pygobject-3.40.1-r1:3[cairo?,${PYTHON_USEDEP}]
			x11-libs/gtk+:3[introspection]
		)
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

use_setup() {
	local uword="${2:-${1}}"
	if use "${1}"; then
		echo "${uword} = True"
		echo "${uword}agg = True"
	else
		echo "${uword} = False"
		echo "${uword}agg = False"
	fi
}

python_prepare_all() {
# Generates test failures, but fedora does it
#	local PATCHES=(
#		"${FILESDIR}"/${P}-unbundle-pycxx.patch
#		"${FILESDIR}"/${P}-unbundle-agg.patch
#	)
#	rm -r agg24 CXX || die
#	rm -r agg24 || die

	# Affects installed _version.py, bug #854600
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

	local PATCHES=(
		"${FILESDIR}"/matplotlib-3.3.3-disable-lto.patch
		"${FILESDIR}"/matplotlib-3.8.0-test.patch
	)

	# increase lock timeout to 30 s
	sed -i -e 's:retries = 50:retries = 300:' lib/matplotlib/cbook.py || die

	hprefixify setupext.py

	rm -rf libqhull || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-flags -fno-strict-aliasing
	append-cppflags -DNDEBUG  # or get old trying to do triangulation
	tc-export PKG_CONFIG

	unset DISPLAY # bug #278524
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die
}

python_configure() {
	mkdir -p "${BUILD_DIR}" || die

	# create setup.cfg (see setup.cfg.template for any changes).

	# common switches.
	cat > "${BUILD_DIR}"/setup.cfg <<- EOF || die
		[directories]
		basedirlist = ${EPREFIX}/usr
		[provide_packages]
		pytz = False
		dateutil = False
		[libs]
		system_freetype = True
		system_qhull = True
		[packages]
		tests = True
		[gui_support]
		agg = True
		gtk = False
		gtkagg = False
		macosx = False
		pyside = False
		pysideagg = False
		qt4 = False
		qt4agg = False
		$(use_setup cairo)
		$(use_setup gtk3)
		$(use_setup qt5)
		$(use_setup tk)
		$(use_setup wxwidgets wx)
	EOF

	if use gtk3 && use cairo; then
		echo "gtk3cairo = True" >> "${BUILD_DIR}"/setup.cfg || die
	else
		echo "gtk3cairo = False" >> "${BUILD_DIR}"/setup.cfg || die
	fi
}

wrap_setup() {
	local MAKEOPTS=-j1
	local -x MPLSETUPCFG="${BUILD_DIR}"/setup.cfg
	"$@"
}

python_compile() {
	wrap_setup distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_compile_all() {
	if use doc; then
		cd doc || die

		VARTEXFONTS="${T}"/fonts \
		emake SPHINXOPTS= O=-Dplot_formats=png:100 html
	fi
}

src_test() {
	mkdir build || die
	ln -s "${WORKDIR}/freetype-${FT_PV}" build/ || die
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# broken by -Wdefault
		"tests/test_rcparams.py::test_validator_invalid[validate_strlist-arg6-MatplotlibDeprecationWarning]"
		"tests/test_rcparams.py::test_validator_invalid[validate_strlist-arg7-MatplotlibDeprecationWarning]"
		tests/test_testing.py::test_warn_to_fail
		# TODO?
		tests/test_backend_qt.py::test_fig_sigint_override
		# leak tests are fragile
		tests/test_backends_interactive.py::test_figure_leak_20490
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

	case "${ABI}" in
		alpha|arm|hppa|m68k|o32|ppc|s390|sh|sparc|x86)
			EPYTEST_DESELECT+=(
				# too large for 32-bit platforms
				'tests/test_axes.py::test_psd_csd[png]'
			)
			;;
		*)
			;;
	esac

	if use hppa ; then
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
	fi

	# we need to rebuild mpl against bundled freetype, otherwise
	# over 1000 tests will fail because of mismatched font rendering
	grep -v system_freetype "${BUILD_DIR}"/setup.cfg \
		> "${BUILD_DIR}"/test-setup.cfg || die
	local -x MPLSETUPCFG="${BUILD_DIR}"/test-setup.cfg

	esetup.py build -j1 --build-lib="${BUILD_DIR}"/test-lib
	local -x PYTHONPATH=${BUILD_DIR}/test-lib:${PYTHONPATH}

	# speed tests up
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# pretend we're on CI to increase timeouts
	local -x CI=1
	nonfatal epytest --pyargs matplotlib -m "not network" || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all
}
