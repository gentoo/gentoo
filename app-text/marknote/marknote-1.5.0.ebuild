# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.19.0
QTMIN=6.9.1
inherit ecm kde.org xdg

DESCRIPTION="Markdown editor with a wide range of formating options for everyday notes"
HOMEPAGE="https://apps.kde.org/marknote/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="plasma"

DEPEND="
	>=dev-libs/kirigami-addons-1.11.0:6
	dev-libs/md4c
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	kde-apps/kmime:6=
	>=kde-frameworks/breeze-icons-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	plasma? (
		>=dev-qt/qtbase-${QTMIN}:6[dbus]
		>=kde-frameworks/krunner-${KFMIN}:6
		>=kde-frameworks/kwindowsystem-${KFMIN}:6
	)
"
RDEPEND="${DEPEND}
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
"

# https://invent.kde.org/office/marknote/-/merge_requests/213
PATCHES=( "${FILESDIR}/${P}-with_krunner.patch" )

src_configure() {
	local mycmakeargs=(
		-DWITH_KRUNNER=$(usex plasma)
	)

	ecm_src_configure
}
