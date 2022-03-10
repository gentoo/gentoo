# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

EGIT_COMMIT="81a4730778fba6b5c76242d3c8da6dace7e2ec0a"
MY_P=python-semanticversion-${EGIT_COMMIT}
DESCRIPTION="Python library providing a few tools handling SemVer in Python"
HOMEPAGE="https://pypi.org/project/semantic-version/"
SRC_URI="
	https://github.com/rbarrois/python-semanticversion/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_test() {
	epytest -p no:django
}
