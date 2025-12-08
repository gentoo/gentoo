# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Terminal string styling done right, in Python"
HOMEPAGE="
	https://pypi.org/project/colorful/
	https://github.com/timofurrer/colorful/
"
SRC_URI="
	https://github.com/timofurrer/colorful/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest -s
}
