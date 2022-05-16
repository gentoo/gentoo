# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )

inherit distutils-r1

DESCRIPTION="A tiny pythonic visitor implementation"
HOMEPAGE="https://github.com/mbr/visitor"
# PyPI tarballs don't include tests
# https://github.com/mbr/visitor/pull/2
SRC_URI="https://github.com/mbr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
