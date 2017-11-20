# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Implementation of the WebSocket protocol for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

IUSE="examples qml +ssl"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtnetwork-${PV}[ssl=]
	qml? ( ~dev-qt/qtdeclarative-${PV} )

"
RDEPEND="${DEPEND}"

QT5_EXAMPLES_SUBDIRS=(
	examples
)

src_prepare() {
	qt_use_disable_mod qml quick \
		src/src.pro \
		examples/websockets/websockets.pro

	qt5-build_src_prepare
}
