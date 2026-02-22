# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Simple assertion library for unit testing in python with a fluent API"
HOMEPAGE="
	https://github.com/assertpy/assertpy/
	https://pypi.org/project/assertpy/
"
# no tests in sdist
SRC_URI="
	https://github.com/assertpy/assertpy/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
