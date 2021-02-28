# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python version of node-semver, the semantic versioner for npm"
HOMEPAGE="
	https://pypi.org/project/node-semver/
	https://github.com/podhmo/python-semver
	https://github.com/npm/node-semver
"
# 0.8.0 has no tarball on PyPi
# https://github.com/podhmo/python-semver/issues/43
SRC_URI="https://github.com/podhmo/python-semver/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-semver-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest
