# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qtbase"
VIRTUALX_REQUIRED="test"
inherit qt5-build

DESCRIPTION="OpenGL support library for the Qt5 framework (deprecated)"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~sparc ~x86"
fi

IUSE="gles2"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2=]
	~dev-qt/qtwidgets-${PV}[gles2=]
	virtual/opengl
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/opengl
)

src_configure() {
	local myconf=(
		-opengl $(usex gles2 es2 desktop)
	)
	qt5-build_src_configure
}
