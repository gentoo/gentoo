# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="The 3D module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

# TODO: egl, tools
IUSE="gles2 qml"

DEPEND="
	~dev-qt/qtconcurrent-${PV}
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	sys-libs/zlib
	qml? ( ~dev-qt/qtdeclarative-${PV}[gles2=] )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt5-build_src_prepare

	if ! use qml; then
		sed -i -e "/quick3d/s/^/#/" src/src.pro || die
	fi
}
