# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P=kiwi-${PV}
DESCRIPTION="An efficient C++ implementation of the Cassowary constraint solving algorithm"
HOMEPAGE="https://github.com/nucleic/kiwi/"
SRC_URI="
	https://github.com/nucleic/kiwi/archive/${PV}.tar.gz -> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Clear-BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

COMMON_DEPEND="
	>=dev-python/cppy-1.2.0[${PYTHON_USEDEP}]
"

RDEPEND="
	${COMMON_DEPEND}
"
BDEPEND="
	${COMMON_DEPEND}
	>=dev-python/setuptools_scm-3.4.3[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
