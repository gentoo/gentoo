# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Chart component library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

DEPEND="
	=dev-qt/qtbase-${PV}*[gui,opengl,widgets]
	=dev-qt/qtdeclarative-${PV}*
"
RDEPEND="${DEPEND}"
