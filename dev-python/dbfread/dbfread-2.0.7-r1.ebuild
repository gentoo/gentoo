# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Read DBF Files with Python"
HOMEPAGE="
	https://github.com/olemb/dbfread/
	https://pypi.org/project/dbfread/
"
SRC_URI+="
	test? (
		https://github.com/olemb/dbfread/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64-macos ~x64-macos"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	dbfread/test_read_and_length.py::test_len
	dbfread/test_read_and_length.py::test_list
)

python_prepare_all() {
	sed -e 's|\[pytest\]|[tool:pytest]|' -i setup.cfg || die
	distutils-r1_python_prepare_all
}
