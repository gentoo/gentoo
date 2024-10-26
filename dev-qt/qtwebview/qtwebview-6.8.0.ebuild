# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Module for displaying web content in a QML application using the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm64"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui]
	~dev-qt/qtdeclarative-${PV}:6
	~dev-qt/qtwebengine-${PV}:6[qml]
"
DEPEND="${RDEPEND}"
