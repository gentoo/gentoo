# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1 verify-sig

DESCRIPTION="Python library and command line tool for configuring a YubiKey"
HOMEPAGE="https://developers.yubico.com/yubikey-manager/"
# According to https://github.com/Yubico/yubikey-manager/issues/518 the release
# tarballs on Yubico Web site and on GitHub should be identical, and at least
# for recent releases the latter are signed as well. Only the automatically
# generated "Source code (tar.gz)" tarballs should not be used.
SRC_URI="https://github.com/Yubico/${PN}/releases/download/${PV}/${P}.tar.gz -> ${P}.gh.tar.gz
	verify-sig? ( https://github.com/Yubico/${PN}/releases/download/${PV}/${P}.tar.gz.sig -> ${P}.gh.tar.gz.sig )"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="ssl"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/yubico.com.asc"

# app-crypt/ccid required for
# - 'ykman oath'
# - 'ykman openpgp'
# - 'ykman piv'
RDEPEND="
	app-crypt/ccid
	dev-python/click[${PYTHON_USEDEP}]
	<dev-python/cryptography-39[${PYTHON_USEDEP}]
	dev-python/fido2:0/1.0[${PYTHON_USEDEP}]
	dev-python/pyscard[${PYTHON_USEDEP}]
	ssl? ( >=dev-python/pyopenssl-0.15.1[${PYTHON_USEDEP}] )"
BDEPEND="
	test? ( dev-python/makefun[${PYTHON_USEDEP}] )
	verify-sig? ( >=sec-keys/openpgp-keys-yubico-20220824 )"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	doman man/ykman.1
}
