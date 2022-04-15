# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=68f420ebdfb226e3d0c09ebed06d5454cc6c3a7f
inherit qt5-build

DESCRIPTION="Translation files for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="ppc ppc64"
fi

IUSE=""

DEPEND="=dev-qt/qtcore-${QT5_PV}*"
BDEPEND="=dev-qt/linguist-tools-${QT5_PV}*"
