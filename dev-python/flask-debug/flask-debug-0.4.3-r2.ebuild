# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

MY_P="Flask-Debug-${PV}"
DESCRIPTION="Flask extension that displays various debugging insights during development"
HOMEPAGE="
	https://github.com/mbr/Flask-Debug/
	https://pypi.org/project/Flask-Debug/
"
# PyPI tarballs don't include tests
# https://github.com/mbr/Flask-Debug/pull/2
SRC_URI="
	https://github.com/mbr/Flask-Debug/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/inflection[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/alabaster
