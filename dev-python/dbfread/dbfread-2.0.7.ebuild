# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Read DBF Files with Python"
HOMEPAGE="https://github.com/olemb/dbfread https://pypi.org/project/dbfread/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? ( https://github.com/olemb/dbfread/archive/refs/tags/${PV}.tar.gz ->  ${P}-src.tar.gz )"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND=""

distutils_enable_tests pytest

python_prepare_all() {
	sed -e 's|\[pytest\]|[tool:pytest]|' -i setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	local pytest_args test_name xfails

	xfails=(
		dbfread/test_read_and_length.py::test_len
		dbfread/test_read_and_length.py::test_list
	)

	for test_name in "${xfails[@]}"; do
		pytest_args+=(--deselect "${test_name}")
	done

	epytest "${pytest_args[@]}"
}
