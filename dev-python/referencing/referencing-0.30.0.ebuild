# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

SUITE_COMMIT=6e126a9fc8f243c4948feb11a7b66efda9d71098
SUITE_P=referencing-suite-${SUITE_COMMIT}

DESCRIPTION="Cross-specification JSON referencing (JSON Schema, OpenAPI...)"
HOMEPAGE="
	https://github.com/python-jsonschema/referencing/
	https://pypi.org/project/referencing/
"
SRC_URI+="
	test? (
		https://github.com/python-jsonschema/referencing-suite/archive/${SUITE_COMMIT}.tar.gz
			-> ${SUITE_P}.gh.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/attrs-22.2.0[${PYTHON_USEDEP}]
	>=dev-python/rpds-py-0.7.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x REFERENCING_SUITE=${WORKDIR}/${SUITE_P}
	epytest
}
