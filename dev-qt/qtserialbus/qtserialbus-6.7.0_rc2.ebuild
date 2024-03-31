# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt module to access CAN, ModBus, and other industrial serial buses and protocols"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[network]
	~dev-qt/qtserialport-${PV}:6
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# rarely fails randomly (perhaps related to -j)
	tst_qcandbcfileparser
)

src_install() {
	qt6-build_src_install

	if use test; then
		local delete=( # sigh
			"${D}${QT6_LIBDIR}"/cmake/Qt6SerialBus/*TestCanBusPlugin*.cmake
			"${D}${QT6_MKSPECSDIR}"/modules/qt_plugin_qttestcanbus.pri
			"${D}${QT6_PLUGINDIR}"/canbus/libqttestcanbus.*
			"${D}${QT6_PLUGINDIR}"/canbus/objects-*/
		)
		# using -f given not tracking which tests may be skipped or not
		rm -rf -- "${delete[@]}" || die
	fi
}
