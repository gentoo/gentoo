# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=${P/_beta/b}
DESCRIPTION="JSONSchema Spec with object-oriented paths"
HOMEPAGE="
	https://pypi.org/project/jsonschema-path/
	https://github.com/p1c2u/jsonschema-path/
"
SRC_URI="
	https://github.com/p1c2u/jsonschema-path/archive/${PV/_beta/b}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
if [[ ${PV} != *_beta* ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

RDEPEND="
	>=dev-python/pathable-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/pyrsistent-0.20.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/referencing-0.28.1[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/--cov/d' pyproject.toml || die
	# remove random pins
	sed -i -e 's:\^:>=:' -e 's:<[0-9.]\+:*:' pyproject.toml || die
	distutils-r1_src_prepare
}
