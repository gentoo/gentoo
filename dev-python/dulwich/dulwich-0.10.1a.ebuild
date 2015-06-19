# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dulwich/dulwich-0.10.1a.ebuild,v 1.1 2015/06/03 23:21:42 mrueg Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Pure-Python implementation of the Git file formats and protocols"
HOMEPAGE="https://github.com/jelmer/dulwich/ http://pypi.python.org/pypi/dulwich"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/gevent[$(python_gen_usedep python2_7)] )"
RDEPEND=""

DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# https://github.com/jelmer/dulwich/issues/196
	if [[ "${EPYTHON}" == pypy ]]; then
		"${PYTHON}" -m unittest dulwich.tests.test_suite || die "Tests failed under pypy"
	else
		emake check
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
