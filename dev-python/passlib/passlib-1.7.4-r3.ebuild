# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Password hashing framework supporting over 20 schemes"
HOMEPAGE="
	https://foss.heptapod.net/python-libs/passlib/-/wikis/home
	https://pypi.org/project/passlib/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="doc test-rust"

BDEPEND="
	test? (
		dev-python/scrypt[${PYTHON_USEDEP}]
		test-rust? (
			dev-python/bcrypt[${PYTHON_USEDEP}]
			dev-python/cryptography[${PYTHON_USEDEP}]
		)
	)"

distutils_enable_tests pytest

src_prepare() {
	# fix compatibility with >=dev-python/bcrypt-4.1
	# https://foss.heptapod.net/python-libs/passlib/-/issues/190
	sed -i -e '/bcrypt/s:__about__\.::' passlib/handlers/bcrypt.py || die

	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# broken all the time by new django releases
		passlib/tests/test_ext_django.py
	)

	case ${EPYTHON} in
		python3.13*|python3.14*)
			EPYTEST_DESELECT+=(
				# crypt module has been removed, so the platform backend
				# does not work anymore
				passlib/tests/test_handlers.py::{des,md5,sha256,sha512}_crypt_os_crypt_test
			)
			;;
	esac

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
