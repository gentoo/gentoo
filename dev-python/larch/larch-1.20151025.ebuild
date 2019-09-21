# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Copy-on-write B-tree data structure"
HOMEPAGE="https://liw.fi/larch/"
SRC_URI="http://git.liw.fi/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/cliapp[${PYTHON_USEDEP}]
	dev-python/tracing[${PYTHON_USEDEP}]
	dev-python/ttystatus[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-python/coverage-test-runner[${PYTHON_USEDEP}] dev-util/cmdtest )"

PATCHES=(
	"${FILESDIR}"/${P}-coverage-4.0a6-compatibility.patch
)

src_test() {
	addwrite /proc/self/comm
	distutils-r1_src_test
}

python_test() {
	emake check
}
