# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1 optfeature

DESCRIPTION="Password hashing framework supporting over 20 schemes"
HOMEPAGE="
	https://foss.heptapod.net/python-libs/passlib/-/wikis/home
	https://pypi.org/project/passlib/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
SLOT="0"
IUSE="doc"

BDEPEND="
	test? (
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/scrypt[${PYTHON_USEDEP}]
		!alpha? ( !hppa? ( !ia64? (
			dev-python/cryptography[${PYTHON_USEDEP}]
		) ) )
	)"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# broken all the time by new django releases
		passlib/tests/test_ext_django.py
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
