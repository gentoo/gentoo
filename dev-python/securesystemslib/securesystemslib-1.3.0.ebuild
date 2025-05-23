# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Cryptographic routines for Secure Systems Lab projects at NYU"
HOMEPAGE="
	https://github.com/secure-systems-lab/securesystemslib/
	https://pypi.org/project/securesystemslib/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/cryptography-40.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# TODO: unbundle https://github.com/pyca/ed25519 (wtf? not on PyPI?)

python_test() {
	local EPYTEST_DESELECT=(
		# requires pyspx
		tests/test_signer.py::TestSphincs::test_sphincs
	)
	local EPYTEST_IGNORE=(
		# requires PyKCS11
		tests/test_hsm_signer.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
