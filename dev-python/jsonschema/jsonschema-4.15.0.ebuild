# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="An implementation of JSON-Schema validation for Python"
HOMEPAGE="
	https://pypi.org/project/jsonschema/
	https://github.com/python-jsonschema/jsonschema/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	>=dev-python/pyrsistent-0.18.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_resources-1.4.0[${PYTHON_USEDEP}]
		dev-python/pkgutil_resolve_name[${PYTHON_USEDEP}]
	' 3.8)
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
	dev-python/uri_template[${PYTHON_USEDEP}]
	>=dev-python/webcolors-1.11[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires pip, does not make much sense for the users
	jsonschema/tests/test_cli.py::TestCLIIntegration::test_license
	# wtf?
	jsonschema/tests/test_deprecations.py::TestDeprecations::test_version
	jsonschema/tests/test_jsonschema_test_suite.py::test_suite_bug
)
