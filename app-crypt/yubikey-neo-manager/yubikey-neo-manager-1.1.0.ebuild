# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Cross platform personalization tool for the YubiKey NEO"
HOMEPAGE="https://developers.yubico.com/yubikey-neo-manager/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="
	dev-python/pyside[webkit,${PYTHON_USEDEP}]
	app-crypt/libu2f-host
	app-crypt/libykneomgr
	sys-auth/ykpers"

DEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/nose-1.0[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	${CDEPEND}"

RDEPEND="${CDEPEND}"

DOCS=( NEWS README )

python_test() {
	nosetests || die
}

python_install_all() {
	distutils-r1_python_install_all

	doman scripts/neoman.1
	domenu resources/neoman.desktop
	doicon resources/neoman.xpm
	newicon -s 128 resources/neoman-large.png neoman.png
}
