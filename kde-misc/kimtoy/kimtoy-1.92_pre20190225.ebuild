# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
COMMIT="c8b3da65bfd289d0a0262aa673aa6b697022d4a3"
inherit ecm kde.org

DESCRIPTION="Input method frontend for Plasma"
HOMEPAGE="https://www.linux-apps.com/content/show.php?content=140967"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="5"
IUSE="libressl scim semantic-desktop"

DEPEND="
	app-i18n/ibus
	dev-libs/glib:2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	media-libs/libpng:0=[apng]
	x11-libs/libX11
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	scim? (
		>=app-i18n/scim-1.4.9
		dev-libs/dbus-c++
	)
	semantic-desktop? ( >=kde-frameworks/kfilemetadata-${KFMIN}:5 )
"
RDEPEND="${DEPEND}
	!kde-misc/kimtoy:4
	>=app-i18n/fcitx-4.0
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	ecm_src_prepare

	# bug 581736
	cmake_comment_add_subdirectory po
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package scim SCIM)
		$(cmake_use_find_package scim DBusCXX)
		$(cmake_use_find_package semantic-desktop KF5FileMetaData)
	)

	ecm_src_configure
}
