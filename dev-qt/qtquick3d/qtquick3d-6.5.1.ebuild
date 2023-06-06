# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt module and API for defining 3D content in Qt QuickTools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
elif [[ ${QT6_BUILD_TYPE} == live ]]; then
	# Don't clone qtquick3d-assimp.
	EGIT_SUBMODULES=()
fi

DEPEND="
	=dev-qt/qtbase-${PV}*[concurrent,network,widgets]
	=dev-qt/qtdeclarative-${PV}*
	=dev-qt/qtshadertools-${PV}*
	=dev-qt/qtquicktimeline-${PV}*
	media-libs/assimp:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DQT_FEATURE_system_assimp=ON
	)

	qt6-build_src_configure
}
