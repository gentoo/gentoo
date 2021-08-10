# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

MY_P=jmespath.py-${PV}
DESCRIPTION="JSON Matching Expressions"
HOMEPAGE="https://github.com/jmespath/jmespath.py
	https://pypi.org/project/jmespath/"
SRC_URI="
	https://github.com/jmespath/jmespath.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests nose
