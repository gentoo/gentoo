# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Cross platform personalization tool for the YubiKey NEO"
HOMEPAGE="https://developers.yubico.com/yubikey-neo-manager/"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="
	dev-python/pyside[webkit,${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	app-crypt/libu2f-host
	app-crypt/libykneomgr
	sys-auth/ykpers"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"

RDEPEND="${CDEPEND}"

PATCHES=(
	# PySide does not distribute egg-info, so remove it from deps
	"${FILESDIR}"/${PN}-fix-pyside-requirement.patch
)

DOCS=( NEWS README )

python_install_all() {
	distutils-r1_python_install_all

	doman man/neoman.1
	domenu resources/neoman.desktop
	doicon resources/neoman.xpm
	newicon -s 128 resources/yubikey-neo-manager.png neoman.png
}
