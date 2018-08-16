# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit eutils qmake-utils python-single-r1

DESCRIPTION="Cross-platform application for configuring any YubiKey over all USB transports"
HOMEPAGE="https://developers.yubico.com/yubikey-manager-qt https://github.com/Yubico/yubikey-manager-qt"
SRC_URI="https://github.com/Yubico/yubikey-manager-qt/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=app-crypt/yubikey-manager-0.7.0[${PYTHON_USEDEP}]
	<app-crypt/yubikey-manager-0.8
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyotherside[${PYTHON_USEDEP}]
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtdeclarative:5
	dev-qt/qtsvg:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/"

src_prepare() {
	default

	sed -i -e "s/ykman-cli//" ${PN}.pro || die
	sed -e "/qtsingleapplication.pri/d" \
		-e "/CONFIG += c++11/a CONFIG += qtsingleapplication" \
		-i ykman-gui/ykman-gui.pro || die

	# See: https://github.com/Yubico/yubikey-manager-qt/issues/54
	echo "${PV}" > "${S}"/VERSION || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake install INSTALL_ROOT="${D}"

	domenu resources/ykman-gui.desktop
	doicon -s 128 resources/icons/ykman.png
	doicon -s scalable resources/icons/ykman.svg

	einstalldocs
}
