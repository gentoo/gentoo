# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt Tools Collection"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="
	assistant designer distancefieldgenerator +linguist pixeltool
	qdbus qdoc qtattributionsscanner qtdiag qtplugininfo
"

DEPEND="
	=dev-qt/qtbase-${PV}*[network]
	assistant? ( =dev-qt/qtbase-${PV}*[sql,widgets] )
	designer? ( =dev-qt/qtbase-${PV}*[widgets] )
	distancefieldgenerator? (
		=dev-qt/qtbase-${PV}*[widgets]
		=dev-qt/qtdeclarative-${PV}*
	)
	pixeltool? ( =dev-qt/qtbase-${PV}*[widgets] )
	qdbus? ( =dev-qt/qtbase-${PV}*[widgets] )
	qdoc? ( sys-devel/clang:= )
	qtdiag? ( =dev-qt/qtbase-${PV}*[opengl,widgets] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(qt_feature assistant)
		-DQT_FEATURE_commandlineparser=ON
		$(qt_feature designer)
		$(qt_feature distancefieldgenerator)
		$(qt_feature linguist)
		$(qt_feature pixeltool)
		$(qt_feature qdbus)
		$(qt_feature qdoc clang)
		$(qt_feature qtattributionsscanner)
		$(qt_feature qtdiag)
		$(qt_feature qtplugininfo)
		-DQT_FEATURE_thread=ON
	)

	qt6-build_src_configure
}
