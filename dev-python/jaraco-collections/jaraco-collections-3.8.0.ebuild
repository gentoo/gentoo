# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Models and classes to supplement the stdlib collections module"
HOMEPAGE="
	https://github.com/jaraco/jaraco.collections/
	https://pypi.org/project/jaraco.collections/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/.}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/jaraco-classes[${PYTHON_USEDEP}]
	dev-python/jaraco-text[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
