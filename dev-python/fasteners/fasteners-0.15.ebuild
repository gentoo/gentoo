# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python package that provides useful locks"
HOMEPAGE="https://github.com/harlowja/fasteners"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/monotonic-0.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest
