# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build

DESCRIPTION="Legacy declarative UI module for the Qt5 framework (deprecated)"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

IUSE="designer gles2 opengl webkit xml"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtscript-${PV}
	~dev-qt/qtsql-${PV}
	~dev-qt/qtwidgets-${PV}
	designer? (
		~dev-qt/designer-${PV}
		~dev-qt/qtdeclarative-${PV}
	)
	opengl? (
		~dev-qt/qtgui-${PV}[gles2=]
		~dev-qt/qtopengl-${PV}
	)
	webkit? ( ~dev-qt/qtwebkit-${PV} )
	xml? ( ~dev-qt/qtxmlpatterns-${PV} )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod designer designer \
		src/plugins/plugins.pro

	qt_use_disable_mod opengl opengl \
		src/imports/imports.pro \
		tools/qml/qml.pri

	qt_use_disable_mod webkit webkitwidgets \
		src/imports/imports.pro

	qt_use_disable_mod xml xmlpatterns \
		src/declarative/declarative.pro \
		src/declarative/util/util.pri

	qt5-build_src_prepare
}
