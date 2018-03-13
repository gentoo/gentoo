# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="A library to help people understand how their memory is being used in Python."
HOMEPAGE="https://pypi.python.org/pypi/meliae"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/cython
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile() {
	python_is_python3 || local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	local lib="$(ls "${BUILD_DIR}/lib/${PN}/"*.so | head -n1)"
	ln -s "${lib}" "${PN}" || die
	py.test || die "tests failed with ${EPYTHON}"
	rm "${PN}/$(basename "${lib}")" || die
}
