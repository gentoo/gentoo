# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="A featureful, correct URL for Python"
HOMEPAGE="https://github.com/python-hyper/hyperlink https://pypi.org/project/hyperlink/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/idna[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
