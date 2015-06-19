# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/gunicorn/gunicorn-0.17.4.ebuild,v 1.3 2014/03/03 23:31:50 pacho Exp $

EAPI="5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.1 *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

DESCRIPTION="A WSGI HTTP Server for UNIX"
HOMEPAGE="http://gunicorn.org http://pypi.python.org/pypi/gunicorn"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="doc test"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/setproctitle"
DEPEND="dev-python/setuptools
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest )"

DOCS="README.rst"

src_prepare() {
	# these tests requires an already installed version of gunicorn
	rm tests/test_003-config.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		cd docs
		sphinx-build -b html source build || die "Generation of documentation failed"
	fi
}

src_install() {
	distutils_src_install

	use doc && dohtml -r docs/build/
}
