# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="An implementation of JSON-Schema validation for Python"
HOMEPAGE="https://pypi.org/project/jsonschema/ https://github.com/Julian/jsonschema"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/pyrsistent-0.18.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
	' pypy3)
"

# formatter deps
RDEPEND+="
		dev-python/fqdn[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/isoduration[${PYTHON_USEDEP}]
		>=dev-python/jsonpointer-1.13[${PYTHON_USEDEP}]
		dev-python/rfc3339-validator[${PYTHON_USEDEP}]
		dev-python/rfc3986-validator[${PYTHON_USEDEP}]
		dev-python/rfc3987[${PYTHON_USEDEP}]
		dev-python/uritemplate[${PYTHON_USEDEP}]
		>=dev-python/webcolors-1.11[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/twisted[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires pip, does not make much sense for the users
	jsonschema/tests/test_cli.py::TestCLIIntegration::test_license
)
