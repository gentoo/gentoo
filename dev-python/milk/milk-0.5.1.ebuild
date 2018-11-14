# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Machine learning toolkit in Python"
HOMEPAGE="http://luispedro.org/software/milk"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/numpy"
DEPEND="dev-python/setuptools
	dev-cpp/eigen:3
	test? ( dev-python/milksets sci-libs/scipy[${PYTHON_USEDEP}] )"
