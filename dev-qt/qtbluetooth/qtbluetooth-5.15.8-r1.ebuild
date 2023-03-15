# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=2
	KEYWORDS="~amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
fi

QT5_MODULE="qtconnectivity"
inherit qt5-build

DESCRIPTION="Bluetooth support library for the Qt5 framework"

IUSE="qml"

DEPEND="
	=dev-qt/qtconcurrent-${QT5_PV}*
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtdbus-${QT5_PV}*
	=dev-qt/qtnetwork-${QT5_PV}*
	>=net-wireless/bluez-5:=
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/nfc//' src/src.pro || die

	qt_use_disable_mod qml quick src/src.pro

	qt5-build_src_prepare
}
