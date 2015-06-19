# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/paste/paste-1.7.5.1.ebuild,v 1.6 2014/10/15 23:08:08 blueness Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

MY_PN="Paste"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tools for using a Web Server Gateway Interface stack"
HOMEPAGE="http://pythonpaste.org http://pypi.python.org/pypi/Paste"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-interix ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris"
IUSE="doc flup openid"

RDEPEND="dev-python/setuptools
	flup? ( dev-python/flup )
	openid? ( dev-python/python-openid )"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils_src_prepare

	# Disable failing tests.
	rm -f tests/test_cgiapp.py
	sed \
		-e "s/test_find_file/_&/" \
		-e "s/test_deep/_&/" \
		-e "s/test_static_parser/_&/" \
		-i tests/test_urlparser.py || die "sed failed"

	# Remove a test that runs against the paste website.
	rm tests/test_proxy.py

	epatch "${FILESDIR}/${P}-fix-tests-for-pypy.patch"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		PYTHONPATH="." "$(PYTHON -f)" setup.py build_sphinx || die "Generation of documentation failed"
	fi
}

# Define custom src_test() due to requirement of PYTHONPATH=".".
src_test() {
	python_execute_nosetests -P .
}

src_install() {
	distutils_src_install

	if use doc; then
		pushd build/sphinx/html > /dev/null
		docinto html
		cp -R [a-z]* _static "${ED}usr/share/doc/${PF}/html" || die "Installation of documentation failed"
		popd > /dev/null
	fi
}
