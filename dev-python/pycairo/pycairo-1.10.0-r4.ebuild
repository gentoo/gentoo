# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='threads(+)'

inherit eutils python-r1 waf-utils toolchain-funcs

PYCAIRO_PYTHON2_VERSION="${PV}"
PYCAIRO_PYTHON3_VERSION="${PV}"

DESCRIPTION="Python bindings for the cairo library"
HOMEPAGE="http://cairographics.org/pycairo/ https://pypi.python.org/pypi/pycairo"
SRC_URI="http://cairographics.org/releases/py2cairo-${PYCAIRO_PYTHON2_VERSION}.tar.bz2
	http://cairographics.org/releases/pycairo-${PYCAIRO_PYTHON3_VERSION}.tar.bz2"

# LGPL-3 for pycairo 1.10.0.
# || ( LGPL-2.1 MPL-1.1 ) for pycairo 1.8.10.
LICENSE="LGPL-3 || ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples +svg test xcb"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Note: xpyb is used as the C header, not Python modules
RDEPEND="${PYTHON_DEPS}
	>=x11-libs/cairo-1.10.0[svg?,xcb?]
	xcb? ( x11-libs/xpyb )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

src_prepare() {

	pushd "${WORKDIR}/pycairo-${PYCAIRO_PYTHON3_VERSION}" > /dev/null
	rm -f src/config.h || die
	epatch "${FILESDIR}/${PN}-1.10.0-svg_check.patch"
	epatch "${FILESDIR}/${PN}-1.10.0-xpyb.patch"
	epatch "${FILESDIR}/${PN}-1.10.0-waf-unpack.patch"
	epatch "${FILESDIR}"/py2cairo-1.10.0-ppc-darwin.patch
	popd > /dev/null

	pushd "${WORKDIR}/py2cairo-${PYCAIRO_PYTHON2_VERSION}" > /dev/null
	rm -f src/config.h || die
	epatch "${FILESDIR}/py2cairo-1.10.0-svg_check.patch"
	epatch "${FILESDIR}/py2cairo-1.10.0-xpyb.patch"
	epatch "${FILESDIR}"/py2cairo-1.10.0-ppc-darwin.patch
	popd > /dev/null

	preparation() {
		if python_is_python3; then
			cp -r -l "${WORKDIR}/pycairo-${PYCAIRO_PYTHON3_VERSION}" "${BUILD_DIR}" || die
			pushd "${BUILD_DIR}" > /dev/null
			wafdir="$(./waf unpack)"
			pushd "${wafdir}" > /dev/null
			epatch "${FILESDIR}/${PN}-1.10.0-waf-py3_4.patch"
			popd > /dev/null
			popd > /dev/null
		else
			cp -r -l "${WORKDIR}/py2cairo-${PYCAIRO_PYTHON2_VERSION}" "${BUILD_DIR}" || die
		fi
	}
	python_foreach_impl preparation
}

src_configure() {
	if ! use svg; then
		export PYCAIRO_DISABLE_SVG=1
	fi

	if ! use xcb; then
		export PYCAIRO_DISABLE_XPYB=1
	fi

	tc-export PKG_CONFIG
	# Also export the var with the slightly diff name that waf uses for no good reason.
	export PKGCONFIG=${PKG_CONFIG}

	# Added by grobian:
	# If WAF_BINARY is an absolute path, the configure is different and fails to
	# find Python.h due to a compiler misconfiguration.  If WAF_BINARY is just
	# ./waf or python waf, it works fine.  Hooray for reinvented buildsystems

	# floppym:
	# pycairo and py2cairo bundle different versions of waf (bug 447856)
	WAF_BINARY="./waf"
	python_foreach_impl run_in_build_dir waf-utils_src_configure --nopyc --nopyo
}

src_compile() {
	python_foreach_impl run_in_build_dir waf-utils_src_compile
}

src_test() {
	test_installation() {
		./waf install --destdir="${T}/tests/${BUILD_DIR}"
		PYTHONPATH="${T}/tests/${BUILD_DIR}$(python_get_sitedir)" py.test -v
	}
	python_foreach_impl run_in_build_dir test_installation
}

src_install() {
	python_foreach_impl run_in_build_dir waf-utils_src_install

	dodoc AUTHORS NEWS README

	if use doc; then
		pushd doc/_build/html > /dev/null || die
		dohtml -r [a-z]* _static
		popd > /dev/null || die
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fix install_names; next to waf producing dylibs (not bundles) and
		# calling them .bundle, it also has no idea what it should do to create
		# proper ones (dylibs)
		fix_darwin_install_names() {
			local x="$(python_get_sitedir)/cairo/_cairo.bundle"
			install_name_tool -id "${x}" "${ED}${x}"
		}
		python_foreach_impl fix_darwin_install_names
	fi
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null || die
	"$@"
	popd > /dev/null || die
}
