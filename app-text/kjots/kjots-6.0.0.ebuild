# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="pim"
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="Note taking utility by KDE"
HOMEPAGE="https://userbase.kde.org/KJots https://community.kde.org/PIM/KJots"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="speech"

DEPEND="
	>=dev-libs/ktextaddons-1.5.0:6[speech?]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-apps/akonadi-24.02.0:6
	>=kde-apps/akonadi-notes-24.02.0:6
	>=kde-apps/kmime-24.02.0:6
	>=kde-apps/kontactinterface-24.02.0:6
	>=kde-apps/kpimtextedit-24.02.0:6
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/ktexttemplate-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	>=kde-apps/kdepim-runtime-24.02.0:6
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package speech KF6TextEditTextToSpeech)
	)

	ecm_src_configure
}
