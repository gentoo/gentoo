# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="A package resource and symbol loading helper library"
HOMEPAGE="https://pypi.org/project/asset/ https://github.com/metagriffin/asset"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/aadict-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/globre-0.0.5[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/pxml-0.2.11[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests --verbose || die
}
