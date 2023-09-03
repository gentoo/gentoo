# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Physical position determination library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="geoclue +qml"

DEPEND="
	~dev-qt/qtbase-${PV}:6[gui,widgets]
	~dev-qt/qtserialport-${PV}:6
	geoclue? ( ~dev-qt/qtbase-${PV}:6[dbus] )
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
"
RDEPEND="
	${DEPEND}
	geoclue? ( app-misc/geoclue:2.0 )
"

src_prepare() {
	qt6-build_src_prepare

	# would use $(cmake_use_find_package geoclue Qt6DBus) but doing
	# this side-disables gui+qml if do have qtbase[dbus]
	use geoclue ||
		sed -e 's/TARGET Qt::DBus/FALSE/' \
			-i src/plugins/position/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
	)

	qt6-build_src_configure
}

src_install() {
	qt6-build_src_install

	if use test; then
		local delete=( # sigh
			"${D}${QT6_LIBDIR}"/cmake/Qt6Positioning/*DummyPlugin*.cmake
			"${D}${QT6_LIBDIR}"/cmake/Qt6Positioning/*TestPlugin*.cmake
			"${D}${QT6_PLUGINDIR}"/position/libqtposition_satellitesourcetest.so
			"${D}${QT6_PLUGINDIR}"/position/libqtposition_testplugin{,2}.so
		)
		# using -f given not tracking which tests may be skipped or not
		rm -f -- "${delete[@]}" || die
	fi
}
