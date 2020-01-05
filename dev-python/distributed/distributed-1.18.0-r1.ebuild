# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python library for distributed computation"
HOMEPAGE="https://distributed.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/dask-0.14.1[${PYTHON_USEDEP}]
	>=dev-python/joblib-0.10.2[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	>=dev-python/partd-0.3.7[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/sortedcollections[${PYTHON_USEDEP}]
	dev-python/tblib[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.7.4[${PYTHON_USEDEP}]
	dev-python/zict[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	py.test -vv -m "not avoid_travis" distributed \
		-r s \
		--timeout-method=thread \
		--timeout=300 \
		--durations=20 || die
}
