# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="The Declarative module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="alpha arm hppa ia64 ppc ppc64"
else
	KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="+accessibility qt3support webkit"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[accessibility=,aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	~dev-qt/qtopengl-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	~dev-qt/qtscript-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtsql-${PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	~dev-qt/qtsvg-${PV}[accessibility=,aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtxmlpatterns-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	qt3support? ( ~dev-qt/qt3support-${PV}[accessibility=,aqua=,debug=,${MULTILIB_USEDEP}] )
	webkit? ( ~dev-qt/qtwebkit-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/declarative
	src/imports
	src/plugins/qmltooling
	tools/qml
	tools/qmlplugindump"

QCONFIG_ADD="declarative"
QCONFIG_DEFINE="QT_DECLARATIVE"

pkg_setup() {
	use webkit && QT4_TARGET_DIRECTORIES+="
		src/3rdparty/webkit/Source/WebKit/qt/declarative"
}

multilib_src_configure() {
	local myconf=(
		-declarative -no-gtkstyle
		$(qt_use accessibility)
		$(qt_use qt3support)
		$(qt_use webkit)
	)
	qt4_multilib_src_configure
}
