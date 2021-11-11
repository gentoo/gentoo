# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit desktop python-single-r1 qmake-utils xdg

DESCRIPTION="Library and tool for personalization of Yubico's YubiKey NEO"
HOMEPAGE="
	https://developers.yubico.com/yubioath-desktop/
	https://github.com/Yubico/yubioath-desktop"
SRC_URI="https://github.com/Yubico/yubioath-desktop/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtdeclarative:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	x11-libs/libdrm"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '>=app-crypt/yubikey-manager-4.0.0[${PYTHON_USEDEP}]')
	dev-python/pyotherside[${PYTHON_SINGLE_USEDEP}]"

src_prepare() {
	default
	sed -i \
		-e "s:python build_qrc.py:${PYTHON} build_qrc.py:" \
		yubioath-desktop.pro || die

	python_fix_shebang "${S}"
}

src_configure() {
	eqmake5 yubioath-desktop.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	domenu resources/com.yubico.yubioath.desktop
	doicon resources/icons/com.yubico.yubioath.png
	doicon -s scalable resources/icons/com.yubico.yubioath.svg
}
