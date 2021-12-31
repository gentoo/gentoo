# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="A set of mixin classes and other helpers for unittest test case classes"
HOMEPAGE="https://github.com/nedbat/unittest-mixins https://pypi.org/project/unittest-mixins/"
SRC_URI="https://github.com/nedbat/unittest-mixins/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/six-1.10.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
