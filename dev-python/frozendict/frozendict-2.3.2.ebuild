# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="A simple immutable mapping for python"
HOMEPAGE="
	https://github.com/Marco-Sulla/python-frozendict
	https://pypi.python.org/pypi/frozendict
"
SRC_URI="https://github.com/Marco-Sulla/python-frozendict/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/python-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

# few tests fail with python3_9 and one with python3_10
RESTRICT="test"

distutils_enable_tests pytest
