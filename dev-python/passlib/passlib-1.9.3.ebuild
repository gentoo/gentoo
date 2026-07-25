# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_PN=libpass
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Fork of passlib, a password hashing framework"
HOMEPAGE="
	https://github.com/notypecheck/passlib/
	https://pypi.org/project/libpass/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="doc test-rust"

BDEPEND="
	test? (
		dev-python/scrypt[${PYTHON_USEDEP}]
		test-rust? (
			>=dev-python/bcrypt-3.1.0[${PYTHON_USEDEP}]
			>=dev-python/cryptography-43.0.1[${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# bcrypt now disallows implicit password truncation
		# https://github.com/notypecheck/passlib/pull/25
		tests/test_handlers_bcrypt.py::bcrypt_bcrypt_test::test_70_hashes
		tests/test_handlers_bcrypt.py::bcrypt_bcrypt_test::test_secret_w_truncate_size
		tests/test_handlers_django.py::django_bcrypt_test::test_secret_w_truncate_size

		# assumes scrypt dep is not installed
		tests/test_crypto_scrypt.py::BuiltinScryptTest::test_missing_backend
	)

	# skip fuzzing tests, they are very slow
	epytest -k "not fuzz_input"
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && dodoc docs/{*.rst,requirements.txt,lib/*.rst}
}

pkg_postinst() {
	optfeature "Argon2 support" dev-python/argon2-cffi
	optfeature "bcrypt support" dev-python/bcrypt
	optfeature "scrypt support" dev-python/scrypt
	optfeature "Time-based One-Time Password (TOTP) support" dev-python/cryptography
}
