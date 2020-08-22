# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
inherit distutils-r1

DESCRIPTION="Robust and reusable Executor for joblib"
HOMEPAGE="https://github.com/joblib/loky"
SRC_URI="
	https://github.com/joblib/loky/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-cloudpickle-1.5.patch
)

src_prepare() {
	# docker, seriously?
	sed -e 's:test_cpu_count_cfs_limit:_&:' \
		-i tests/test_loky_module.py || die

	distutils-r1_src_prepare
}
