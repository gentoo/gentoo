# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 flag-o-matic multiprocessing prefix pypi
inherit toolchain-funcs virtualx

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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="cairo doc excel examples gtk3 latex qt5 tk webagg wxwidgets"

# internal copy of pycxx highly patched
#	dev-python/pycxx
RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/contourpy-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/cycler-0.10.0-r1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.22.0[${PYTHON_USEDEP}]
	>=dev-python/kiwisolver-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-7.1.1[jpeg,webp,${PYTHON_USEDEP}]
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
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	)
	webagg? (
		>=dev-python/tornado-6.0.4[${PYTHON_USEDEP}]
	)
	wxwidgets? (
		$(python_gen_cond_dep '
			dev-python/wxpython:*[${PYTHON_USEDEP}]
		' python3_{8..10})
	)
"

BDEPEND="
	${RDEPEND}
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
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.40.1-r1:3[cairo?,${PYTHON_USEDEP}]
		>=dev-python/tornado-6.0.4[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
	)
"

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
		"${FILESDIR}"/matplotlib-3.7.1-test.patch
	)

	sed \
		-e 's/matplotlib.pyparsing_py[23]/pyparsing/g' \
		-i lib/matplotlib/{mathtext,fontconfig_pattern}.py \
		|| die "sed pyparsing failed"
	sed -i -e '/setuptools_scm/s:,<7::' setup.py || die

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
		# unhappy about xdist
		tests/test_widgets.py::test_span_selector_animated_artists_callback
	)
	[[ ${EPYTHON} == python3.11 ]] && EPYTEST_DESELECT+=(
		# https://github.com/matplotlib/matplotlib/issues/23384
		"tests/test_backends_interactive.py::test_figure_leak_20490[time_mem1-{'MPLBACKEND': 'qtagg', 'QT_API': 'PyQt5'}]"
		"tests/test_backends_interactive.py::test_figure_leak_20490[time_mem1-{'MPLBACKEND': 'qtcairo', 'QT_API': 'PyQt5'}]"
	)

	# we need to rebuild mpl against bundled freetype, otherwise
	# over 1000 tests will fail because of mismatched font rendering
	grep -v system_freetype "${BUILD_DIR}"/setup.cfg \
		> "${BUILD_DIR}"/test-setup.cfg || die
	local -x MPLSETUPCFG="${BUILD_DIR}"/test-setup.cfg

	esetup.py build -j1 --build-lib="${BUILD_DIR}"/test-lib
	local -x PYTHONPATH=${BUILD_DIR}/test-lib:${PYTHONPATH}

	# speed tests up
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	nonfatal epytest --pyargs matplotlib -m "not network" \
		-p xdist.plugin -n "$(makeopts_jobs)" || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
