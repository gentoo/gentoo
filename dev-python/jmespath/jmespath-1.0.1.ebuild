# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

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
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

EPYTEST_IGNORE=(
	# fuzzing tests, they take forever
	extra/test_hypothesis.py
)

distutils_enable_tests pytest
