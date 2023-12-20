# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="A friendly onboarding wizard for Plasma"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="discover +kaccounts telemetry"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-plasma/libplasma-${KFMIN}:5
	kaccounts? ( kde-apps/kaccounts-integration:5 )
	telemetry? ( kde-frameworks/kuserfeedback:5 )
"
RDEPEND="${DEPEND}
	discover? ( kde-plasma/discover:5 )
"

PATCHES=( "${FILESDIR}/${PN}-5.27.4.1-kaccounts-optional.patch" )

src_prepare() {
	ecm_src_prepare

	if ! use discover; then
		sed -e "s:pageStack.push(discover);:// & disabled by IUSE=discover:" \
			-i src/contents/ui/main.qml || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kaccounts KAccounts)
		$(cmake_use_find_package telemetry KUserFeedback)
	)
	ecm_src_configure
}
