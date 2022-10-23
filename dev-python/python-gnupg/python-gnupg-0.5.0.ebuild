# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/vinaysajip.asc
inherit distutils-r1 verify-sig

DESCRIPTION="A Python wrapper for GnuPG"
HOMEPAGE="https://docs.red-dove.com/python-gnupg/"
SRC_URI="https://github.com/vsajip/python-gnupg/releases/download/${PV}/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://github.com/vsajip/python-gnupg/releases/download/${PV}/${P}.tar.gz.asc )"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
LICENSE="BSD"
SLOT="0"

# Need gnupg[nls] for avoiding decode errors and possible hangs
# w/ e.g. sec-keys/openpgp-keys-gentoo-developers but other pkgs too.
RDEPEND="app-crypt/gnupg[nls]"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-vinaysajip )"

distutils_enable_tests unittest

python_test() {
	# NO_EXTERNAL_TESTS must be enabled,
	# to disable all tests, which need internet access.
	NO_EXTERNAL_TESTS=1 eunittest
}
