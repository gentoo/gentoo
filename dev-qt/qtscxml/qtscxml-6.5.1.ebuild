# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="State Chart XML (SCXML) support library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE=""

DEPEND="
	=dev-qt/qtbase-${PV}*[gui,network,opengl,widgets]
	=dev-qt/qtdeclarative-${PV}*
"
RDEPEND="${DEPEND}"
