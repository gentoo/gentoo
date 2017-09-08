# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit qmake-utils python-single-r1 vcs-snapshot

DESCRIPTION="Cross-platform application for configuring any YubiKey over all USB transports"
HOMEPAGE="https://developers.yubico.com/yubikey-manager-qt https://github.com/Yubico/yubikey-manager-qt"
SRC_URI="https://github.com/Yubico/yubikey-manager-qt/archive/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-crypt/yubikey-manager[${PYTHON_USEDEP}]
	dev-python/pyotherside[${PYTHON_USEDEP}]
	dev-qt/qtsingleapplication[qt5]
	dev-qt/qtdeclarative:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	rm -rf vendor ykman-gui/vendor || die
	sed -i -e "s/ykman-cli//" ${PN}.pro || die
	sed -i -e "/qtsingleapplication.pri/d" -e "/CONFIG += c++11/a CONFIG += qtsingleapplication" -i ykman-gui/ykman-gui.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
