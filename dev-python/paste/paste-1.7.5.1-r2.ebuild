# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/paste/paste-1.7.5.1-r2.ebuild,v 1.3 2015/04/08 08:05:09 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
# notes wrt py-3 compatibility:
# Debian ships paste for py3 using 2to3. Many tests fail when using such converted code and
# the fact that the errors are sometimes nested inside paste indicate that the
# result is indeed broken. Upstream is not responsive nor interested in porting.

inherit distutils-r1

MY_PN="Paste"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tools for using a Web Server Gateway Interface stack"
HOMEPAGE="http://pythonpaste.org http://pypi.python.org/pypi/Paste"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-interix ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc flup openid"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/tempita-0.5.2_pre20130828[${PYTHON_USEDEP}]
	flup? ( dev-python/flup[${PYTHON_USEDEP}] )
	openid? ( dev-python/python-openid[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Disable failing tests.
	rm -f tests/test_cgiapp.py
	sed \
		-e "s/test_find_file/_&/" \
		-e "s/test_deep/_&/" \
		-e "s/test_static_parser/_&/" \
		-i tests/test_urlparser.py || die "sed failed"

	# Remove a test that runs against the paste website.
	rm -f tests/test_proxy.py

	local PATCHES=(
		"${FILESDIR}/${P}-fix-tests-for-pypy.patch"
		"${FILESDIR}/${P}-python27-lambda.patch"
		"${FILESDIR}/${P}-unbundle-stdlib.patch"
		"${FILESDIR}/${P}-unbundle-tempita.patch"
		"${FILESDIR}/${P}-userdict.patch"
		"${FILESDIR}/${P}-rfc822.patch"
		"${FILESDIR}/${P}-email-mime.patch"
		"${FILESDIR}/${P}-types.patch"
		"${FILESDIR}/${P}-hmac.patch"
	)

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile egg_info --egg-base "${BUILD_DIR}/lib"
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	nosetests -P || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install egg_info --egg-base "${BUILD_DIR}/lib"
}

python_install_all() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	distutils-r1_python_install_all
}
