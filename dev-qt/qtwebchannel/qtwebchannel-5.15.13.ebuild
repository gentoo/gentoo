# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

inherit qt5-build

DESCRIPTION="Qt5 module for integrating C++ and QML applications with HTML/JavaScript clients"

IUSE="qml"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod qml quick src/src.pro
	qt_use_disable_mod qml qml src/webchannel/webchannel.pro

	qt5-build_src_prepare
}
