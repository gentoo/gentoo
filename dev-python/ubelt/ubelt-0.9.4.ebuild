# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A stdlib like feel, and extra batteries. Hashing, Caching, Timing, Progress"
HOMEPAGE="https://github.com/Erotemic/ubelt"
SRC_URI="https://github.com/Erotemic/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	dev-python/ordered-set[${PYTHON_USEDEP}]"

DEPEND="test? ( dev-python/xdoctest[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# relies on passwd being equal to ${HOME}
		ubelt/util_path.py::userhome:0
	)

	pytest -vv ${deselect[@]/#/--deselect } tests ||
		die "Tests fail with ${EPYTHON}"
}
