# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Asynchronous SSHv2 client and server library"
HOMEPAGE="
	https://github.com/ronf/asyncssh
	https://pypi.org/project/asyncssh/
"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/openssh
	>=dev-python/cryptography-39.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/aiofiles[${PYTHON_USEDEP}]
		>=dev-python/bcrypt-3.1.3[${PYTHON_USEDEP}]
		>=dev-python/fido2-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/gssapi-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/libnacl-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-23.0.0[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest
distutils_enable_sphinx docs

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p rerunfailures --reruns=5
}

pkg_postinst() {
	optfeature "OpenSSH private key encryption support" ">=dev-python/bcrypt-3.1.3"
	optfeature "key exchange and authentication with U2F/FIDO2 security keys support" ">=dev-python/fido2-0.9.2"
	optfeature "GSSAPI key exchange and authentication support" ">=dev-python/gssapi-1.2.0"
	optfeature "using asyncssh with dev-libs/libsodium" "dev-python/libnacl"
	optfeature "X.509 certificate authentication support" ">=dev-python/pyopenssl-23.0.0"
}
