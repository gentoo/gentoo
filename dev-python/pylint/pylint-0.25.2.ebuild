# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python code static checker"
HOMEPAGE="http://www.logilab.org/project/pylint https://pypi.python.org/pypi/pylint"
SRC_URI="ftp://ftp.logilab.org/pub/${PN}/${P}.tar.gz mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="examples"

# Versions specified in __pkginfo__.py.
RDEPEND=">=dev-python/logilab-common-0.53.0[${PYTHON_USEDEP}]
	>=dev-python/astng-0.24.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${PN}-0.26.0-gtktest.patch )

python_test() {
	# Test suite broken with Python 3
	local msg="Test suite broken with ${EPYTHON}"
	if [[ "${EPYTHON}" == python3* ]]; then
		einfo "${msg}"
	else
		# https://bitbucket.org/logilab/pylint/issue/11/apparent-regression-in-testsuite-pylint
		# This 'issue' became' declared fixed by accident for version 0.27.0 despite being made citing 0.28.0
		pytest || die "Tests failed under ${EPYTHON}"
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	doman man/{pylint,pyreverse}.1

	if use examples; then
		docinto examples
		dodoc examples/*
	fi
}

pkg_postinst() {
	# Optional dependency on "tk" USE flag would break support for Jython.
	elog "pylint-gui script requires dev-lang/python with \"tk\" USE flag enabled."
}
