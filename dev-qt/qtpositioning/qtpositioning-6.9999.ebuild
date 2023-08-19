# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Physical position determination library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

DEPEND="
	=dev-qt/qtbase-${PV}*[dbus,gui,widgets]
	=dev-qt/qtdeclarative-${PV}*
	=dev-qt/qtserialport-${PV}*
"
RDEPEND="${DEPEND}"
