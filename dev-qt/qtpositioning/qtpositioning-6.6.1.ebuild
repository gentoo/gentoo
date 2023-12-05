# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Physical position determination library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="geoclue nmea +qml"

DEPEND="
	~dev-qt/qtbase-${PV}:6
	geoclue? ( ~dev-qt/qtbase-${PV}:6[dbus] )
	nmea? (
		~dev-qt/qtbase-${PV}:6[network]
		~dev-qt/qtserialport-${PV}:6
	)
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
"
RDEPEND="
	${DEPEND}
	geoclue? ( app-misc/geoclue:2.0 )
"

src_prepare() {
	qt6-build_src_prepare

	# unfortunately cmake_use_find_package would break things with qtbase
	use geoclue ||
		sed -e 's/TARGET Qt::DBus/FALSE/' \
			-i src/plugins/position/CMakeLists.txt || die
	use nmea ||
		sed -e 's/TARGET Qt::Network/FALSE/' \
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
