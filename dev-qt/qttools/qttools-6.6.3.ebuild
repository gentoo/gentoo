# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {15..18} )
LLVM_OPTIONAL=1
inherit desktop llvm-r1 optfeature qt6-build

DESCRIPTION="Qt Tools Collection"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

IUSE="
	+assistant clang designer distancefieldgenerator gles2-only
	+linguist opengl pixeltool +qdbus qdoc qml qtattributionsscanner
	qtdiag qtplugininfo vulkan +widgets zstd
"
# note that some tools do not *require* widgets but will skip a sub-tool
# if not enabled (e.g. linguist gives lrelease but not the GUI linguist6)
REQUIRED_USE="
	assistant? ( widgets )
	clang? ( ${LLVM_REQUIRED_USE} )
	designer? ( qml widgets )
	distancefieldgenerator? ( qml widgets )
	pixeltool? ( widgets )
	qdoc? ( clang qml )
"

# behaves very badly when qttools is not already installed, also
# other more minor issues (clang tests flaky depending on version,
# and 3rdparty/ tries to FetchContent gtest)
RESTRICT="test"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[network,widgets?]
	assistant? ( ~dev-qt/qtbase-${PV}:6[sql,sqlite] )
	clang? (
		$(llvm_gen_dep '
			sys-devel/clang:${LLVM_SLOT}=
			sys-devel/llvm:${LLVM_SLOT}=
		')
	)
	designer? (
		~dev-qt/qtbase-${PV}:6[xml,zstd=]
		zstd? ( app-arch/zstd:= )
	)
	qdbus? ( ~dev-qt/qtbase-${PV}:6[dbus,xml] )
	qml? ( ~dev-qt/qtdeclarative-${PV}:6[widgets?] )
	qtdiag? ( ~dev-qt/qtbase-${PV}:6[gles2-only=,vulkan=] )
	widgets? ( ~dev-qt/qtbase-${PV}:6[opengl=] )
"
DEPEND="
	${RDEPEND}
	qtdiag? (
		vulkan? ( dev-util/vulkan-headers )
	)
"

pkg_setup() {
	use clang && llvm-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		# prevent the clang test as it can abort due to bug #916098
		$(cmake_use_find_package clang WrapLibClang)
		$(cmake_use_find_package qml Qt6Qml)
		$(cmake_use_find_package widgets Qt6Widgets)
		$(qt_feature assistant)
		$(qt_feature clang)
		$(qt_feature designer)
		$(qt_feature distancefieldgenerator)
		$(qt_feature linguist)
		$(qt_feature pixeltool)
		$(qt_feature qdbus)
		$(qt_feature qdoc)
		$(qt_feature qtattributionsscanner)
		$(qt_feature qtdiag)
		$(qt_feature qtplugininfo)

		# TODO?: package litehtml, but support for latest releases seem
		# to lag behind and bundled may work out better for now
		# https://github.com/litehtml/litehtml/issues/266
		$(usev assistant -DCMAKE_DISABLE_FIND_PACKAGE_litehtml=ON)

		$(usev designer -DQT_UNITY_BUILD=OFF) # fails to build (QTBUG-122634)
	)

	qt6-build_src_configure
}

src_install() {
	qt6-build_src_install

	if use widgets; then #914766
		use designer || use distancefieldgenerator || use pixeltool &&
			newicon src/designer/src/designer/images/designer.png designer6.png

		if use assistant; then
			make_desktop_entry assistant6 'Qt 6 Assistant' assistant6 \
				'Qt;Development;Documentation' \
				'Comment=Tool for viewing online documentation in Qt help file format'
			newicon src/assistant/assistant/images/assistant-128.png assistant6.png
		fi

		if use designer; then
			make_desktop_entry designer6 'Qt 6 Designer' designer6 \
				'Qt;Development;GUIDesigner' \
				'Comment=WYSIWYG tool for designing and building graphical user interfaces with QtWidgets'
		fi

		if use distancefieldgenerator; then
			# no icon, sharing with designer which fits letter-wise
			make_desktop_entry qdistancefieldgenerator6 'Qt 6 Distance Field Generator' designer6 \
				'Qt;Development' \
				'Comment=Tool for pregenerating the font cache of Qt applications'
		fi

		if use linguist; then
			make_desktop_entry linguist6 'Qt 6 Linguist' linguist6 \
				'Qt;Development;Translation' \
				'Comment=Tool for translating Qt applications'
			newicon src/linguist/linguist/images/icons/linguist-128-32.png linguist6.png
		fi

		if use pixeltool; then
			# no icon, not fitting but share with designer for now
			make_desktop_entry pixeltool6 'Qt 6 Pixel Tool' designer6 \
				'Qt;Development' \
				'Comment=Tool for zooming in the desktop area pointed by the cursor'
		fi

		if use qdbus; then
			make_desktop_entry qdbusviewer6 'Qt 6 QDBusViewer' qdbusviewer6 \
				'Qt;Development' \
				'Comment=Tool that lets introspect D-Bus objects and messages'
			newicon src/qdbus/qdbusviewer/images/qdbusviewer-128.png qdbusviewer6.png
		fi

		# hack: make_destop_entry does not support overriding DESCRIPTION
		find "${ED}" -type f -name "*.desktop" \
			-exec sed -i "/^Comment=${DESCRIPTION}/d" -- {} + || die
	fi
}

pkg_postinst() {
	use assistant &&
		optfeature "Qt documentation viewable in assistant" \
			'dev-qt/qt-docs:6[qch]' #602296
}
