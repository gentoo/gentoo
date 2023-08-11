# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="An implementation of JSON-Schema validation for Python"
HOMEPAGE="
	https://pypi.org/project/jsonschema/
	https://github.com/python-jsonschema/jsonschema/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/attrs-22.2.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-specifications-2023.03.6[${PYTHON_USEDEP}]
	>=dev-python/referencing-0.28.4[${PYTHON_USEDEP}]
	>=dev-python/rpds-py-0.7.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
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
	dev-python/uri-template[${PYTHON_USEDEP}]
	>=dev-python/webcolors-1.11[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires pip, does not make much sense for the users
	jsonschema/tests/test_cli.py::TestCLIIntegration::test_license
	# fragile warning tests
	jsonschema/tests/test_deprecations.py
	# wtf?
	jsonschema/tests/test_jsonschema_test_suite.py::test_suite_bug
)
