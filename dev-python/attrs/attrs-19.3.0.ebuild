# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Attributes without boilerplate"
HOMEPAGE="
	https://github.com/hynek/attrs
	https://attrs.readthedocs.org/
	https://pypi.org/project/attrs/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-python/zope-interface[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep sqlite)
		>=dev-python/hypothesis-3.6.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.3.0[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
