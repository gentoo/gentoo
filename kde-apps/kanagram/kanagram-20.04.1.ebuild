# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.70.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Game based on anagrams of words"
HOMEPAGE="https://kde.org/applications/education/org.kde.kanagram
https://edu.kde.org/kanagram/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="speech"

DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	>=kde-apps/libkeduvocdocument-${PVCUT}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	media-libs/phonon[qt5(+)]
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
"
RDEPEND="${DEPEND}
	>=kde-apps/kdeedu-data-${PVCUT}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5[qml]
	>=dev-qt/qtquickcontrols-${QTMIN}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package speech Qt5TextToSpeech)
	)

	ecm_src_configure
}
