# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 verify-sig

DESCRIPTION="A Python wrapper for GnuPG"
HOMEPAGE="
	https://docs.red-dove.com/python-gnupg/
	https://github.com/vsajip/python-gnupg/
	https://pypi.org/project/python-gnupg/
"
SRC_URI="
	https://github.com/vsajip/python-gnupg/releases/download/${PV}/${P}.tar.gz
	verify-sig? (
		https://github.com/vsajip/python-gnupg/releases/download/${PV}/${P}.tar.gz.asc
	)
"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86"
LICENSE="BSD"
SLOT="0"

# Need gnupg[nls] for avoiding decode errors and possible hangs
# w/ e.g. sec-keys/openpgp-keys-gentoo-developers but other pkgs too.
DEPEND="
	app-crypt/gnupg[nls]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-vinaysajip )
"

distutils_enable_tests unittest

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/vinaysajip.asc

python_test() {
	# NO_EXTERNAL_TESTS must be enabled,
	# to disable all tests, which need internet access.
	NO_EXTERNAL_TESTS=1 eunittest
}
