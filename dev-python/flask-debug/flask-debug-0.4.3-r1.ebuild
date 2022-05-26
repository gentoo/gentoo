# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

MY_PN="Flask-Debug"
DESCRIPTION="Flask extension that displays various debugging insights during development"
HOMEPAGE="https://github.com/mbr/Flask-Debug"
# PyPI tarballs don't include tests
# https://github.com/mbr/Flask-Debug/pull/2
SRC_URI="https://github.com/mbr/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/inflection[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/alabaster
