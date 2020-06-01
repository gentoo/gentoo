# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE='tk?,threads(+)'

DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 flag-o-matic virtualx toolchain-funcs prefix

DESCRIPTION="Pure python plotting library with matlab like syntax"
HOMEPAGE="https://matplotlib.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
# Main license: matplotlib
# Some modules: BSD
# matplotlib/backends/qt4_editor: MIT
# Fonts: BitstreamVera, OFL-1.1
LICENSE="BitstreamVera BSD matplotlib MIT OFL-1.1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="cairo doc excel examples gtk3 latex qt5 tk wxwidgets"

REQUIRED_USE="
	test? (
		cairo latex qt5 tk wxwidgets gtk3
	)
"

# internal copy of pycxx highly patched
#	dev-python/pycxx

RDEPEND="
	>=dev-python/cycler-0.10.0-r1[${PYTHON_USEDEP}]
	>=dev-python/kiwisolver-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-1.5.6[${PYTHON_USEDEP}]
	dev-python/python-dateutil:0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.14.0[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
	media-fonts/dejavu
	media-fonts/stix-fonts
	media-libs/freetype:2
	media-libs/libpng:0
	>=media-libs/qhull-2013
	>=www-servers/tornado-6.0.4[${PYTHON_USEDEP}]
	cairo? (
		dev-python/cairocffi[${PYTHON_USEDEP}]
	)
	excel? (
		dev-python/xlwt[${PYTHON_USEDEP}]
	)
	gtk3? (
		dev-python/pygobject:3[cairo?,${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
	)
	latex? (
		virtual/latex-base
		app-text/dvipng
		app-text/ghostscript-gpl
		app-text/poppler[utils]
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-xetex
	)
	qt5? (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
	)
	wxwidgets? (
		dev-python/wxpython:*[${PYTHON_USEDEP}]
	)
"

BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? (
		>=app-text/dvipng-1.15-r1
		>=dev-python/colorspacious-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/pillow-7.1.1[${PYTHON_USEDEP}]
		>=dev-python/ipython-1.18.2[${PYTHON_USEDEP}]
		>=dev-python/numpydoc-0.9.2[${PYTHON_USEDEP}]
		>=sci-libs/scipy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-gallery-0.3.1-r1[${PYTHON_USEDEP}]
		>=dev-python/xlwt-1.3.0-r1[${PYTHON_USEDEP}]
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexrecommended
		>=media-gfx/graphviz-2.42.3[cairo]
	)
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

# A few C++ source files are written to srcdir.
# Other than that, the ebuild shall be fit for out-of-source build.
DISTUTILS_IN_SOURCE_BUILD=1

distutils_enable_tests nose

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

	local PATCHES=(
		"${FILESDIR}"/${PN}-3.1.2-qhull.patch
	)

	sed \
		-e 's/matplotlib.pyparsing_py[23]/pyparsing/g' \
		-i lib/matplotlib/{mathtext,fontconfig_pattern}.py \
		|| die "sed pyparsing failed"

	hprefixify setupext.py

	rm -rf libqhull || die

	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	local freetype_version
	freetype_version="$(best_version media-libs/freetype | sed -r -e 's/.*-([0-9].*[0-9])(-r[0-9]+|$)/\1/g')"
	sed -i -r -e "s:(LOCAL_FREETYPE_VERSION =).*:\\1 \"${freetype_version}\":g" setupext.py lib/matplotlib/__init__.py || die

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
		pyside = False
		pysideagg = False
		qt4 = False
		qt4agg = False
		$(use_setup cairo)
		$(use_setup gtk3)
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
	local MAKEOPTS=-j1
	local -x MPLSETUPCFG="${BUILD_DIR}"/setup.cfg
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
		emake SPHINXOPTS= O=-Dplot_formats=png:100 html
	fi
}

python_test() {
	wrap_setup distutils_install_for_testing

	distutils_install_for_testing
	"${EPYTHON}" -c "import sys, matplotlib as m; sys.exit(0 if m.test(verbosity=2) else 1)" || die
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
