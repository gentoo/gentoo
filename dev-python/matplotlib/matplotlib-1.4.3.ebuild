# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

PYTHON_REQ_USE='tk?'

inherit distutils-r1 eutils flag-o-matic virtualx toolchain-funcs

DESCRIPTION="Pure python plotting library with matlab like syntax"
HOMEPAGE="http://matplotlib.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
# Main license: matplotlib
# Some modules: BSD
# matplotlib/backends/qt4_editor: MIT
# Fonts: BitstreamVera, OFL-1.1
LICENSE="BitstreamVera BSD matplotlib MIT OFL-1.1"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="cairo doc excel examples fltk gtk gtk3 latex pyside qt4 qt5 test tk wxwidgets"

PY2_FLAGS="|| ( $(python_gen_useflags python2_7) )"
REQUIRED_USE="
	doc? ( ${PY2_FLAGS} )
	excel? ( ${PY2_FLAGS} )
	fltk? ( ${PY2_FLAGS} )
	gtk? ( ${PY2_FLAGS} )
	wxwidgets? ( ${PY2_FLAGS} )
	test? (
		cairo fltk latex pyside qt5 qt4 tk wxwidgets
		|| ( gtk gtk3 )
		)"

# #456704 -- a lot of py2-only deps
PY2_USEDEP=$(python_gen_usedep python2_7)
COMMON_DEPEND="
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
	dev-python/python-dateutil:0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	media-fonts/stix-fonts
	media-libs/freetype:2
	media-libs/libpng:0
	media-libs/qhull
	gtk? (
		dev-libs/glib:2=
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
		dev-python/pygtk[${PY2_USEDEP}] )
	wxwidgets? ( >=dev-python/wxpython-2.8:*[${PY2_USEDEP}] )"

# internal copy of pycxx highly patched
#	dev-python/pycxx

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? (
		app-text/dvipng
		virtual/python-imaging[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/xlwt[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexrecommended
		media-gfx/graphviz[cairo]
	)
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/nose-0.11.1[${PYTHON_USEDEP}]
		)"

RDEPEND="${COMMON_DEPEND}
	>=dev-python/pyparsing-1.5.6[${PYTHON_USEDEP}]
	cairo? (
		|| (
			dev-python/pycairo[${PYTHON_USEDEP}]
			dev-python/cairocffi[${PYTHON_USEDEP}]
			)
		)
	excel? ( dev-python/xlwt[${PYTHON_USEDEP}] )
	fltk? (
		$(python_gen_cond_dep 'dev-python/pyfltk[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'dev-python/pyfltk[${PYTHON_USEDEP}]' 'python3*')
		)
	gtk3? (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection] )
	latex? (
		virtual/latex-base
		app-text/ghostscript-gpl
		app-text/dvipng
		app-text/poppler[utils]
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-xetex
	)
	pyside? ( dev-python/pyside[X,${PYTHON_USEDEP}] )
	qt4? ( dev-python/PyQt4[X,${PYTHON_USEDEP}] )
	qt5? ( dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}] )
	"

# A few C++ source files are written to srcdir.
# Other than that, the ebuild shall be fit for out-of-source build.
DISTUTILS_IN_SOURCE_BUILD=1

pkg_setup() {
	unset DISPLAY # bug #278524
}

use_setup() {
	local uword="${2:-${1}}"
	if use ${1}; then
		echo "${uword} = True"
		echo "${uword}agg = True"
	else
		echo "${uword} = False"
		echo "${uword}agg = False"
	fi
}

PATCHES=(
	"${FILESDIR}"/${P}-backport-GH5291-2462.patch
)

python_prepare_all() {
# Generates test failures, but fedora does it
#	local PATCHES=(
#		"${FILESDIR}"/${P}-unbundle-pycxx.patch
#		"${FILESDIR}"/${P}-unbundle-agg.patch
#	)
#	rm -r agg24 CXX || die
#	rm -r agg24 || die

	epatch "${FILESDIR}"/${PN}-1.4.3-cross-compile-{1,2,3}.patch

	sed \
		-e 's/matplotlib.pyparsing_py[23]/pyparsing/g' \
		-i lib/matplotlib/{mathtext,fontconfig_pattern}.py \
		|| die "sed pyparsing failed"

	# suggested by upstream
	sed \
		-e '/tol/s:32:35:g' \
		-i lib/matplotlib/tests/test_mathtext.py || die

	sed \
		-e "s:/usr/:${EPREFIX}/usr/:g" \
		-i setupext.py || die

	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	append-flags -fno-strict-aliasing
	append-cppflags -DNDEBUG  # or get old trying to do triangulation
	tc-export PKG_CONFIG
}

python_configure() {
	mkdir -p "${BUILD_DIR}" || die

	# create setup.cfg (see setup.cfg.template for any changes).

	# common switches.
	cat > "${BUILD_DIR}"/setup.cfg <<- EOF
		[directories]
		basedirlist = "${EPREFIX}/usr"
		[provide_packages]
		pytz = False
		dateutil = False
		[gui_support]
		agg = True
		$(use_setup cairo)
		$(use_setup pyside)
		$(use_setup qt4)
		$(use_setup qt5)
		$(use_setup tk)
	EOF

	if use gtk3 && use cairo; then
		echo "gtk3cairo = True" >> "${BUILD_DIR}"/setup.cfg || die
	else
		echo "gtk3cairo = False" >> "${BUILD_DIR}"/setup.cfg || die
	fi

	if $(python_is_python3); then
		cat >> "${BUILD_DIR}"/setup.cfg <<- EOF
			six = True
			fltk = False
			fltkagg = False
			gtk = False
			gtkagg = False
			wx = False
			wxagg = False
		EOF
	else
		cat >> "${BUILD_DIR}"/setup.cfg <<-EOF
			six = False
			$(use_setup fltk)
			$(use_setup gtk)
			$(use_setup gtk3)
			$(use_setup wxwidgets wx)
		EOF
	fi
}

wrap_setup() {
	local MPLSETUPCFG=${BUILD_DIR}/setup.cfg
	export MPLSETUPCFG
	unset DISPLAY

	# Note: remove build... if switching to out-of-source build
	"${@}" build --build-lib="${BUILD_DIR}"/build/lib
}

python_compile() {
	wrap_setup distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		cd doc || die

		# necessary for in-source build
		local -x PYTHONPATH="${BUILD_DIR}"/build/lib:${PYTHONPATH}

		VARTEXFONTS="${T}"/fonts \
		"${PYTHON}" ./make.py --small html || die
	fi
}

python_test() {
	wrap_setup distutils_install_for_testing

	cd "${TMPDIR}" || die
	VIRTUALX_COMMAND="${PYTHON}"
	virtualmake -c "import sys, matplotlib as m; sys.exit(0 if m.test(verbosity=2) else 1)" || \
		die "Tests fail with ${EPYTHON}"
}

python_install() {
	wrap_setup distutils-r1_python_install
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
