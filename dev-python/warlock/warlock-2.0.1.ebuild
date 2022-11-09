# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python object model built on JSON schema and JSON patch"
HOMEPAGE="
	https://github.com/bcwaldon/warlock/
	https://pypi.org/project/warlock/
"
SRC_URI="
	https://github.com/bcwaldon/warlock/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/jsonpatch-1[${PYTHON_USEDEP}]
	<dev-python/jsonpatch-2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-0.7[${PYTHON_USEDEP}]
	<dev-python/jsonschema-5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/--cov/d' pytest.ini || die
	distutils-r1_src_prepare
}
