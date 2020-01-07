# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="A set of mixin classes and other helpers for unittest test case classes"
HOMEPAGE="https://github.com/nedbat/unittest-mixins https://pypi.org/project/unittest-mixins/"
SRC_URI="https://github.com/nedbat/unittest-mixins/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc64 ~sparc"

RDEPEND=">=dev-python/six-1.10.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
