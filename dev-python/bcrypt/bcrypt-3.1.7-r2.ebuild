# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Modern password hashing for software and servers"
HOMEPAGE="https://github.com/pyca/bcrypt/ https://pypi.org/project/bcrypt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris"

COMMON_DEPEND="
	$(python_gen_cond_dep '>=dev-python/cffi-1.1:=[${PYTHON_USEDEP}]' 'python*')
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}"

distutils_enable_tests pytest
