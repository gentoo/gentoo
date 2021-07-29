# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

inherit distutils-r1 optfeature

DESCRIPTION="Python library and command line tool for configuring a YubiKey"
HOMEPAGE="https://developers.yubico.com/yubikey-manager/"
# Per https://github.com/Yubico/yubikey-manager/issues/217, Yubico is
# the official source for tarballs, not Github
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" # Tests require non-existing package makefun

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/fido2:0/0.9[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyscard[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all
	doman man/ykman.1
}

pkg_postinst() {
	optfeature "'ykman oath'" app-crypt/ccid
	optfeature "'ykman openpgp'" app-crypt/ccid
	optfeature "'ykman piv'" app-crypt/ccid
}
