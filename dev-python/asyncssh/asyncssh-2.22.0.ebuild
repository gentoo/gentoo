# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Asynchronous SSHv2 client and server library"
HOMEPAGE="
	https://github.com/ronf/asyncssh/
	https://pypi.org/project/asyncssh/
"

LICENSE="|| ( EPL-2.0 GPL-2+ )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86"

RDEPEND="
	virtual/openssh
	>=dev-python/cryptography-39.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/aiofiles[${PYTHON_USEDEP}]
		>=dev-python/bcrypt-3.1.3[${PYTHON_USEDEP}]
		>=dev-python/gssapi-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/libnacl-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-23.0.0[${PYTHON_USEDEP}]
		amd64? (
			>=dev-python/fido2-2[${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_PLUGINS=()
# xdist: fails on serializing 'type'
distutils_enable_tests pytest
distutils_enable_sphinx docs

pkg_postinst() {
	optfeature "OpenSSH private key encryption support" ">=dev-python/bcrypt-3.1.3"
	optfeature "key exchange and authentication with U2F/FIDO2 security keys support" ">=dev-python/fido2-2"
	optfeature "GSSAPI key exchange and authentication support" ">=dev-python/gssapi-1.2.0"
	optfeature "using asyncssh with dev-libs/libsodium" "dev-python/libnacl"
	optfeature "X.509 certificate authentication support" ">=dev-python/pyopenssl-23.0.0"
}
