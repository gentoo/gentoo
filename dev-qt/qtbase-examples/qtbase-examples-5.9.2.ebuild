# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Examples for cross-platform application development framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="gles2"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2=]
	~dev-qt/qtwidgets-${PV}[gles2=]
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtconcurrent-${PV}
	~dev-qt/qtdbus-${PV}
	~dev-qt/qtopengl-${PV}[gles2=]
	~dev-qt/qtprintsupport-${PV}
	~dev-qt/qtsql-${PV}
	~dev-qt/qttest-${PV}
	~dev-qt/qtxml-${PV}
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	examples
)

src_configure() {
	local myconf=(
		-opengl $(usex gles2 es2 desktop)
	)
	qt5-build_src_configure
}
