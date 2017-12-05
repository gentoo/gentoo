# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE='tk?,threads(+)'

inherit distutils-r1 flag-o-matic virtualx toolchain-funcs prefix

DESCRIPTION="Pure python plotting library with matlab like syntax"
HOMEPAGE="http://matplotlib.org/"
SRC_URI="https://dev.gentoo.org/~grozin/${P}.tar.bz2"

SLOT="0"
# Main license: matplotlib
# Some modules: BSD
# matplotlib/backends/qt4_editor: MIT
# Fonts: BitstreamVera, OFL-1.1
LICENSE="BitstreamVera BSD matplotlib MIT OFL-1.1"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="cairo doc excel examples gtk2 gtk3 latex pyside qt5 test tk wxwidgets"

PY2_FLAGS="|| ( $(python_gen_useflags python2_7) )"
REQUIRED_USE="
	doc? ( ${PY2_FLAGS} )
	excel? ( ${PY2_FLAGS} )
	gtk2? ( ${PY2_FLAGS} )
	wxwidgets? ( ${PY2_FLAGS} )
	test? (
		cairo latex qt5 tk wxwidgets
		|| ( gtk2 gtk3 )
		)"

# #456704 -- a lot of py2-only deps
PY2_USEDEP=$(python_gen_usedep python2_7)
COMMON_DEPEND="
	dev-python/cycler[${PYTHON_USEDEP}]
	dev-python/functools32[${PY2_USEDEP}]
	>=dev-python/numpy-1.7.1[${PYTHON_USEDEP}]
	dev-python/python-dateutil:0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	dev-python/subprocess32[${PY2_USEDEP}]
	media-fonts/stix-fonts
	media-libs/freetype:2
	media-libs/libpng:0
	python_targets_python2_7? ( dev-python/backports-functools-lru-cache[${PY2_USEDEP}] )
	>=media-libs/qhull-2013
	cairo? ( dev-python/cairocffi[${PYTHON_USEDEP}] )
	gtk2? (
		dev-libs/glib:2=
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
		dev-python/pygtk[${PY2_USEDEP}] )
	wxwidgets? ( >=dev-python/wxpython-2.8:*[${PY2_USEDEP}] )"

# internal copy of pycxx highly patched
#	dev-python/pycxx

DEPEND="${COMMON_DEPEND}
	dev-python/versioneer[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		app-text/dvipng
		dev-python/colorspacious[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/mock[${PY2_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/xlwt[${PYTHON_USEDEP}]
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
	excel? ( dev-python/xlwt[${PYTHON_USEDEP}] )
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

python_prepare_all() {
# Generates test failures, but fedora does it
#	local PATCHES=(
#		"${FILESDIR}"/${P}-unbundle-pycxx.patch
#		"${FILESDIR}"/${P}-unbundle-agg.patch
#	)
#	rm -r agg24 CXX || die
#	rm -r agg24 || die

#	cat > lib/${PN}/externals/six.py <<-EOF
#	from __future__ import absolute_import
#	from six import *
#	EOF

	sed \
		-e 's/matplotlib.pyparsing_py[23]/pyparsing/g' \
		-i lib/matplotlib/{mathtext,fontconfig_pattern}.py \
		|| die "sed pyparsing failed"

	hprefixify setupext.py

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
	cat > "${BUILD_DIR}"/setup.cfg <<- EOF || die
		[directories]
		basedirlist = ${EPREFIX}/usr
		[provide_packages]
		pytz = False
		dateutil = False
		[packages]
		tests = $(usex test True False)
		[gui_support]
		agg = True
		qt4 = False
		qt4agg = False
		$(use_setup cairo)
		$(use_setup gtk3)
		$(use_setup pyside)
		$(use_setup qt5)
		$(use_setup tk)
	EOF

	if use gtk3 && use cairo; then
		echo "gtk3cairo = True" >> "${BUILD_DIR}"/setup.cfg || die
	else
		echo "gtk3cairo = False" >> "${BUILD_DIR}"/setup.cfg || die
	fi

	if python_is_python3; then
		cat >> "${BUILD_DIR}"/setup.cfg <<- EOF || die
			gtk = False
			gtkagg = False
			wx = False
			wxagg = False
		EOF
	else
		cat >> "${BUILD_DIR}"/setup.cfg <<-EOF || die
			$(use_setup gtk2 gtk)
			$(use_setup wxwidgets wx)
		EOF
	fi
}

wrap_setup() {
	local -x MPLSETUPCFG=${BUILD_DIR}/setup.cfg
	unset DISPLAY
	"$@"
}

python_compile() {
	wrap_setup distutils-r1_python_compile --build-lib="${BUILD_DIR}"/lib
}

python_compile_all() {
	if use doc; then
		cd doc || die

		# necessary for in-source build
		local -x PYTHONPATH="${BUILD_DIR}"/build/lib:${PYTHONPATH}

		VARTEXFONTS="${T}"/fonts \
		"${EPYTHON}" ./make.py --small html || die
	fi
}

python_test() {
	wrap_setup distutils_install_for_testing

	virtx "${EPYTHON}" -c "import sys, matplotlib as m; sys.exit(0 if m.test(verbosity=2) else 1)"
}

python_install() {
	wrap_setup distutils-r1_python_install

	# mpl_toolkits namespace
	python_moduleinto mpl_toolkits
	python_domodule lib/mpl_toolkits/__init__.py
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${D}" -name '*.pth' -delete || die
}
