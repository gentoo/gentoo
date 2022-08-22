# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Python library and command line tool for configuring a YubiKey"
HOMEPAGE="https://developers.yubico.com/yubikey-manager/"
# Per https://github.com/Yubico/yubikey-manager/issues/217, Yubico is
# the official source for tarballs, not Github.
# Unfortunately in spite of having been mentioned on the Release Notes
# page since mid-July, as of mid-August 2022 there is still no trace
# of an official 4.0.9 tarball.
SRC_URI="https://github.com/Yubico/yubikey-manager/releases/download/${PV}/${P}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="ssl"

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
	test? ( dev-python/makefun[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	doman man/ykman.1
}
