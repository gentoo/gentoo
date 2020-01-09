# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Common PIM libraries"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

# drop qtwidgets subslot operator when QT_MINIMAL >= 5.14.0
COMMON_DEPEND="
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/kpimtextedit-${PVCUT}:5
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5=
	dev-libs/cyrus-sasl
"
DEPEND="${COMMON_DEPEND}
	>=kde-apps/kimap-${PVCUT}:5
	>=kde-apps/kmailtransport-${PVCUT}:5
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"

RESTRICT+=" test"

src_prepare() {
	ecm_src_prepare

	if ! use handbook ; then
		sed -e "/add_subdirectory(doc)/I s/^/#DONOTCOMPILE /" \
			-i kioslave/CMakeLists.txt || die "failed to comment add_subdirectory(doc)"
	fi
}
