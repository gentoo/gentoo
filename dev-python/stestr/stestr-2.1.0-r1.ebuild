# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 python3_6 python3_7 python3_8 )
inherit distutils-r1

DESCRIPTION="A parallel Python test runner built around subunit"
HOMEPAGE="https://github.com/mtreinish/stestr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux"
KEYWORDS="~alpha amd64 arm64 hppa ~ia64 ~mips ~ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/cliff-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/subunit-0.18.0[${PYTHON_USEDEP}]
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.8.9[${PYTHON_USEDEP}]"
