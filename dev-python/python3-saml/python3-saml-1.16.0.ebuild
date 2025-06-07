# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="OneLogin's SAML Python Toolkit"
HOMEPAGE="
	https://github.com/SAML-Toolkits/python3-saml/
	https://pypi.org/project/python3-saml/
"
SRC_URI="
	https://github.com/SAML-Toolkits/python3-saml/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	>=dev-python/isodate-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.9.0[${PYTHON_USEDEP}]
	>=dev-python/xmlsec-1.3.9[${PYTHON_USEDEP}]
"
# next release >1.16.0 should be able to drop freezegun:
# https://github.com/SAML-Toolkits/python3-saml/commit/6c1fbd84ed498841b252ba7eb3a7d81a9ea77d15
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/src/OneLogin/saml2_tests/idp_metadata_parser_test.py::OneLogin_Saml2_IdPMetadataParser_Test::testGetMetadataWithHeaders
		tests/src/OneLogin/saml2_tests/idp_metadata_parser_test.py::OneLogin_Saml2_IdPMetadataParser_Test::testParseRemoteWithHeaders
	)

	# The tests are horribly fragile to paths.
	local -x PYTHONPATH=src
	epytest -o 'python_files=*_test.py'
}
