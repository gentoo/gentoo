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
	qattributionsscanner qdbus qdoc qdiag qplugininfo
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
	qdiag? ( =dev-qt/qtbase-${PV}*[opengl,widgets] )
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
		$(qt_feature qattributionsscanner qtattributionsscanner)
		$(qt_feature qdbus)
		$(qt_feature qdoc clang)
		$(qt_feature qdiag qtdiag)
		$(qt_feature qplugininfo qtplugininfo)
		-DQT_FEATURE_thread=ON
	)

	qt6-build_src_configure
}

src_install() {
	qt6-build_src_install

	use assistant && qt6_symlink_binary_to_path assistant 6
	use designer && qt6_symlink_binary_to_path designer 6
	use distancefieldgenerator && qt6_symlink_binary_to_path qdistancefieldgenerator 6
	use linguist && qt6_symlink_binary_to_path linguist 6
	use pixeltool && qt6_symlink_binary_to_path pixeltool 6
	use qdbus && qt6_symlink_binary_to_path qdbus 6
	use qdbus && qt6_symlink_binary_to_path qdbusviewer 6
	use qdoc && qt6_symlink_binary_to_path qdoc 6
	use qdiag && qt6_symlink_binary_to_path qtdiag 6
	use qplugininfo && qt6_symlink_binary_to_path qtplugininfo 6
}
