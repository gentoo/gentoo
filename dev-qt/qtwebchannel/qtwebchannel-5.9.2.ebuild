# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Qt5 module for integrating C++ and QML applications with HTML/JavaScript clients"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

IUSE="examples qml"
REQUIRED_USE="examples? ( qml )"

DEPEND="
	~dev-qt/qtcore-${PV}
	qml? ( ~dev-qt/qtdeclarative-${PV} )
	examples? (
		~dev-qt/qtwidgets-${PV}
		~dev-qt/qtwebsockets-${PV}
	)
"
RDEPEND="${DEPEND}"

QT5_EXAMPLES_SUBDIRS=(
	examples
)

src_prepare() {
	qt_use_disable_mod qml quick src/src.pro
	qt_use_disable_mod qml qml src/webchannel/webchannel.pro

	qt5-build_src_prepare
}
