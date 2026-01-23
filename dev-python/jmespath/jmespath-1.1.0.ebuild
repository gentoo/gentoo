# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

MY_P=jmespath.py-${PV}
DESCRIPTION="JSON Matching Expressions"
HOMEPAGE="
	https://github.com/jmespath/jmespath.py/
	https://pypi.org/project/jmespath/
"
SRC_URI="
	https://github.com/jmespath/jmespath.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

EPYTEST_IGNORE=(
	# fuzzing tests, they take forever
	extra/test_hypothesis.py
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
