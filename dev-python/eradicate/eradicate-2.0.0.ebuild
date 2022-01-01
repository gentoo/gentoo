# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Removes commented-out code from Python files"
HOMEPAGE="https://github.com/myint/eradicate"
# TODO: revert to PyPI tarball once it includes tests
# https://github.com/myint/eradicate/pull/28
SRC_URI="https://github.com/myint/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests unittest
