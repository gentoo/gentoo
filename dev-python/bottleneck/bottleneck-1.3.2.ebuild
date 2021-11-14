# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Fast NumPy array functions written in Cython"
HOMEPAGE="https://pypi.org/project/Bottleneck/"
SRC_URI="https://github.com/kwgoodman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.9.1[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_test() {
	"${EPYTHON}" ./tools/test-installed-bottleneck.py -vv -m full || die
}
