# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A pure Python implementation of a sliding window memory map manager"
HOMEPAGE="
	https://pypi.org/project/smmap/
	https://github.com/Byron/smmap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm64 ~x86"
SLOT="0"

distutils_enable_tests unittest
