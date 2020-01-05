# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit eutils qmake-utils python-single-r1

DESCRIPTION="Cross-platform application for configuring any YubiKey over all USB transports"
HOMEPAGE="https://developers.yubico.com/yubikey-manager-qt https://github.com/Yubico/yubikey-manager-qt"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="${PYTHON_DEPS}
	>=app-crypt/yubikey-manager-1.0.0[${PYTHON_USEDEP}]
	<app-crypt/yubikey-manager-4.0.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyotherside[${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtquickcontrols2:5[widgets]
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	sed -i -e "s/ykman-cli//" ${PN}.pro || die
	sed -e "/CONFIG += c++11/a CONFIG += qtsingleapplication" \
		-i ykman-gui/ykman-gui.pro || die
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
