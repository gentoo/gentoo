# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYPI_VERIFY_REPO=https://github.com/matplotlib/matplotlib-release
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 pypi virtualx

DESCRIPTION="Pure python plotting library with matlab like syntax"
HOMEPAGE="
	https://matplotlib.org/
	https://github.com/matplotlib/matplotlib/
	https://pypi.org/project/matplotlib/
"

# Main license: matplotlib
# Some modules: BSD
# matplotlib/backends/qt4_editor: MIT
# Fonts: BitstreamVera, OFL-1.1
LICENSE="BitstreamVera BSD matplotlib MIT OFL-1.1"
SLOT="0"
if [[ ${PV} != *_rc* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
fi
IUSE="cairo excel gtk3 latex qt6 tk webagg wxwidgets"

LATEX_DEPEND="
	virtual/latex-base
	app-text/dvipng
	app-text/ghostscript-gpl
	app-text/poppler[cairo,png,utils]
	dev-texlive/texlive-fontsrecommended
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-luatex
	dev-texlive/texlive-xetex
"

DEPEND="
	media-libs/freetype:2
	>=media-libs/raqm-0.10.4:=
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
	>=dev-python/pyparsing-3[${PYTHON_USEDEP}]
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
		${LATEX_DEPEND}
	)
	qt6? (
		$(python_gen_cond_dep '
			|| (
				dev-python/pyqt6[gui,widgets,${PYTHON_USEDEP}]
				dev-python/pyside:6[gui,widgets,${PYTHON_USEDEP}]
			)
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
		$(python_gen_impl_dep 'tk')
		${LATEX_DEPEND}
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

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=3
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Increase lock timeout to 30 s.
	sed -i -e 's:retries = 50:retries = 300:' lib/matplotlib/cbook.py || die
	# Upstream uses 'x86_64' condition to require exact matches no their CI
	# which doesn't match results from other x86_64 systems.
	# Apparently Darwin is given higher tolerances too.
	find -name 'test_*.py' -exec sed -i \
		-e "s:if platform.machine() == 'x86_64' else:if False else:" \
		-e "s:if sys.platform == 'darwin' else:if True else:" \
		{} + || die

	# Enable installing test data.
	# TODO: do it only for the test phase?
	sed -i -e '/--tags/d' pyproject.toml || die
}

src_configure() {
	# Affects installed _version.py, bug #854600
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV/_}

	unset DISPLAY # bug #278524
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	DISTUTILS_ARGS=(
		-Dsystem-freetype=true
		-Dsystem-libraqm=true
		-Dsystem-qhull=true
		-Dmacosx=false
	)
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# broken by -Wdefault
		tests/test_testing.py::test_warn_to_fail
		tests/test_legend.py::test_legend_nolabels_warning
		# TODO: timezone mismatch? DST?
		tests/test_dates.py::test_auto_date_locator_intmult_tz
		# TODO: some latex error
		'tests/test_backend_pdf.py::test_font_heuristica[pdf]'
	)

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# TODO: warning isn't passed through
				tests/test_image.py::test_large_image
				# TODO: regression in 7.3.18+
				tests/test_axes.py::test_axes_clear_reference_cycle
				# TODO
				tests/test_text.py::test_metrics_cache2
			)
			;;
	esac

	# TODO: recheck these
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
			;;
		arm)
			EPYTEST_DESELECT+=(
				tests/test_backend_ps.py::test_savefig_to_stringio
				# too large for 32-bit platforms
				'tests/test_axes.py::test_psd_csd[png]'
			)
			;;
		sparc64)
			EPYTEST_DESELECT+=(
				tests/test_backend_pgf.py::test_pdf_pages_metadata_check
				tests/test_backend_pgf.py::test_minus_signs_with_tex
			)
			;;
		x86)
			EPYTEST_DESELECT+=(
				'tests/test_tightlayout.py::test_tight_layout2[png]'
				'tests/test_patches.py::test_wedge_range[pdf]'
				'tests/test_tightlayout.py::test_tight_layout3[png]'
				'tests/test_quiver.py::test_barbs[png]'
				'tests/test_axes.py::test_fill_between_interpolate_decreasing[png]'
				# too large for 32-bit platforms
				'tests/test_axes.py::test_psd_csd[png]'
			)
			;;
		# NB: The overlap here is deliberate. We copy the same deselect
		# to the blocks above, but if we remove others, it will fall back here.
		alpha|arm|m68k|o32|ppc|s390|sh|sparc|x86)
			EPYTEST_DESELECT+=(
				# too large for 32-bit platforms
				'tests/test_axes.py::test_psd_csd[png]'
			)
			;;
		*)
			;;
	esac

	# pretend we're on CI to increase timeouts
	local -x CI=1
	nonfatal epytest --pyargs matplotlib -m "not network" \
		-o tmp_path_retention_policy=all || die
}
