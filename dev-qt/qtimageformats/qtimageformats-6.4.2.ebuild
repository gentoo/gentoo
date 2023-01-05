# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Additional format plugins for the Qt image I/O system"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="mng"

DEPEND="
	=dev-qt/qtbase-${PV}*[gui]
	media-libs/libwebp:=
	media-libs/tiff:=
	mng? ( media-libs/libmng:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DQT_FEATURE_jasper=OFF
		$(qt_feature mng)
		-DQT_FEATURE_tiff=ON
		-DQT_FEATURE_webp=ON
		-DQT_FEATURE_system_tiff=ON
		-DQT_FEATURE_system_webp=ON
	)

	qt6-build_src_configure
}
