# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="asyncio event loop scheduling callbacks in eventlet"
HOMEPAGE="https://pypi.org/project/aioeventlet/"
SRC_URI="mirror://pypi/a/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/eventlet[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/trollius-0.3[${PYTHON_USEDEP}]' 'python2_7')"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/aiotest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' 'python2_7') )"

python_test() {
	# from tox.ini
	"${PYTHON}" runtests.py -v || die "Tests fail with ${EPYTHON}"
	"${PYTHON}" run_aiotest.py -v || die "Tests fail with ${EPYTHON}"
}
