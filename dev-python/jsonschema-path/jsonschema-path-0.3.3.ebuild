# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="JSONSchema Spec with object-oriented paths"
HOMEPAGE="
	https://pypi.org/project/jsonschema-path/
	https://github.com/p1c2u/jsonschema-path/
"
SRC_URI="
	https://github.com/p1c2u/jsonschema-path/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

# requests seem "optional" but they failed at properly making it
# optional in poetry, sigh
RDEPEND="
	>=dev-python/pathable-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/referencing-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/--cov/d' pyproject.toml || die
	# remove random pins due to caret operator
	sed -i -e 's:\^:>=:' -e 's:,<[0-9.]*::' pyproject.toml || die
	distutils-r1_src_prepare
}
