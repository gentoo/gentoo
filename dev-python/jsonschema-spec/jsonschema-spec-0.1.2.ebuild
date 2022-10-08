# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="JSONSchema Spec with object-oriented paths"
HOMEPAGE="
	https://pypi.org/project/jsonschema-spec/
	https://github.com/p1c2u/jsonschema-spec/
"
SRC_URI="
	https://github.com/p1c2u/jsonschema-spec/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/jsonschema-4.0.0[${PYTHON_USEDEP}]
	dev-python/pathable[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	dev-python/pathable[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/--cov/d' -i pyproject.toml || die
	distutils-r1_src_prepare
}
