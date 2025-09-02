# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
ECM_HANDBOOK="optional"
KDE_ORG_COMMIT=51a96097381ec2b9b6e10106afa9ebf2579e5272
KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm kde.org xdg

DESCRIPTION="Multiple information organizer - a DropDrawers clone"
HOMEPAGE="https://userbase.kde.org/BasKet https://invent.kde.org/utilities/basket"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="crypt git"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kfilemetadata-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	crypt? ( app-crypt/gpgme:= )
	git? ( dev-libs/libgit2:= )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
"
BDEPEND="git? ( virtual/pkgconfig )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_GPG=$(usex crypt)
		$(cmake_use_find_package git Libgit2)
	)
	ecm_src_configure
}
