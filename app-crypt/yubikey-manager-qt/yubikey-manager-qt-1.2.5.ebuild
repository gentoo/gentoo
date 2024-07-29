# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit qmake-utils python-single-r1 desktop xdg

DESCRIPTION="Cross-platform application for configuring any YubiKey over all USB transports"
HOMEPAGE="https://developers.yubico.com/yubikey-manager-qt/ https://github.com/Yubico/yubikey-manager-qt"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=app-crypt/yubikey-manager-5.0.0[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
	')
	dev-python/pyotherside[qt5,${PYTHON_SINGLE_USEDEP}]
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
