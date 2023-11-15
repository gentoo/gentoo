# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Location (places, maps, navigation) library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[network]
	~dev-qt/qtdeclarative-${PV}:6
	~dev-qt/qtpositioning-${PV}:6[qml]
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# ignores QML_IMPORT_PATH (unlike other tests) and looks in
	# the missing builddir/qml, skip rather than work around
	tst_declarative_ui
)

src_install() {
	qt6-build_src_install

	if use test; then
		local delete=( # sigh
			"${D}${QT6_LIBDIR}"/cmake/Qt6Location/*TestGeoServicePlugin*.cmake
			"${D}${QT6_LIBDIR}"/cmake/Qt6Location/*UnsupportedPlacesGeoServicePlugin*.cmake
			"${D}${QT6_LIBDIR}"/cmake/Qt6Qml/QmlPlugins/*declarative_location_test*.cmake
			"${D}${QT6_PLUGINDIR}"/geoservices/libqtgeoservices_geocodingplugin.so
			"${D}${QT6_PLUGINDIR}"/geoservices/libqtgeoservices_placesplugin_unsupported.so
			"${D}${QT6_PLUGINDIR}"/geoservices/libqtgeoservices_qmltestplugin.so
			"${D}${QT6_PLUGINDIR}"/geoservices/libqtgeoservices_routingplugin.so
			"${D}${QT6_QMLDIR}"/QtLocation/Test
		)
		# using -f given not tracking which tests may be skipped or not
		rm -rf -- "${delete[@]}" || die
	fi
}
