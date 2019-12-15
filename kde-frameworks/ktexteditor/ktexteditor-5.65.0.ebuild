# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing a full text editor component"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="editorconfig git"

BDEPEND="
	test? ( >=kde-frameworks/kservice-${PVCUT}:5 )
"
DEPEND="
	>=kde-frameworks/karchive-${PVCUT}:5
	>=kde-frameworks/kauth-${PVCUT}:5
	>=kde-frameworks/kcodecs-${PVCUT}:5
	>=kde-frameworks/kcompletion-${PVCUT}:5
	>=kde-frameworks/kconfig-${PVCUT}:5
	>=kde-frameworks/kconfigwidgets-${PVCUT}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/kguiaddons-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=kde-frameworks/kiconthemes-${PVCUT}:5
	>=kde-frameworks/kio-${PVCUT}:5
	>=kde-frameworks/kitemviews-${PVCUT}:5
	>=kde-frameworks/kjobwidgets-${PVCUT}:5
	>=kde-frameworks/kparts-${PVCUT}:5
	>=kde-frameworks/ktextwidgets-${PVCUT}:5
	>=kde-frameworks/kwidgetsaddons-${PVCUT}:5
	>=kde-frameworks/kxmlgui-${PVCUT}:5
	>=kde-frameworks/sonnet-${PVCUT}:5
	>=kde-frameworks/syntax-highlighting-${PVCUT}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	editorconfig? ( app-text/editorconfig-core-c )
	git? ( dev-libs/libgit2:= )
"
RDEPEND="${DEPEND}"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package editorconfig EditorConfig)
		$(cmake_use_find_package git LibGit2)
	)

	ecm_src_configure
}
