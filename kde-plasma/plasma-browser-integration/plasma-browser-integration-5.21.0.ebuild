# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.78.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Integrate Chrome/Firefox better into Plasma through browser extensions"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kfilemetadata-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/purpose-${KFMIN}:5
	>=kde-plasma/plasma-workspace-${PVCUT}:5
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DMOZILLA_DIR="${EPREFIX}/usr/$(get_libdir)/mozilla"
	)

	ecm_src_configure
}
