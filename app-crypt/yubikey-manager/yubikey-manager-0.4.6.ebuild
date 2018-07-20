# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
inherit distutils-r1

DESCRIPTION="Python library and command line tool for configuring a YubiKey"
HOMEPAGE="https://developers.yubico.com/yubikey-manager/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # Testing requires RSA keys which are not present in the tarball

RDEPEND="
	app-crypt/libu2f-host
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/pyscard[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
	sys-auth/ykpers
"
