# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_DESIGNERPLUGIN="true"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing transparent file and data management"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~x86"
IUSE="acl +handbook kerberos +kwallet X"

RDEPEND="
	>=kde-frameworks/kauth-${PVCUT}:5
	>=kde-frameworks/karchive-${PVCUT}:5
	>=kde-frameworks/kbookmarks-${PVCUT}:5
	>=kde-frameworks/kcodecs-${PVCUT}:5
	>=kde-frameworks/kcompletion-${PVCUT}:5
	>=kde-frameworks/kconfig-${PVCUT}:5
	>=kde-frameworks/kconfigwidgets-${PVCUT}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/kcrash-${PVCUT}:5
	>=kde-frameworks/kdbusaddons-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=kde-frameworks/kiconthemes-${PVCUT}:5
	>=kde-frameworks/kitemviews-${PVCUT}:5
	>=kde-frameworks/kjobwidgets-${PVCUT}:5
	>=kde-frameworks/knotifications-${PVCUT}:5
	>=kde-frameworks/kservice-${PVCUT}:5
	>=kde-frameworks/ktextwidgets-${PVCUT}:5
	>=kde-frameworks/kwidgetsaddons-${PVCUT}:5
	>=kde-frameworks/kwindowsystem-${PVCUT}:5
	>=kde-frameworks/kxmlgui-${PVCUT}:5
	>=kde-frameworks/solid-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	dev-libs/libxml2
	dev-libs/libxslt
	acl? (
		sys-apps/attr
		virtual/acl
	)
	handbook? ( >=kde-frameworks/kdoctools-${PVCUT}:5 )
	kerberos? ( virtual/krb5 )
	kwallet? ( >=kde-frameworks/kwallet-${PVCUT}:5 )
	X? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
	test? ( sys-libs/zlib )
	X? (
		x11-base/xorg-proto
		x11-libs/libX11
		x11-libs/libXrender
	)
"
PDEPEND="
	>=kde-frameworks/kded-${PVCUT}:5
"

# tests hang
RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}/${P}-fix-http-proxy-settings.patch"
	"${FILESDIR}/${P}-fix-ftp-proxy-settings.patch"
	"${FILESDIR}/${P}-fix-no-proxy-settings.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package acl ACL)
		$(cmake_use_find_package handbook KF5DocTools)
		$(cmake_use_find_package kerberos GSSAPI)
		$(cmake_use_find_package kwallet KF5Wallet)
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
