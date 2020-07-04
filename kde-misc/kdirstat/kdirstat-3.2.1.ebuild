# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
inherit ecm

DESCRIPTION="GUI equivalent to the du command based on KDE Frameworks"
HOMEPAGE="https://github.com/jeromerobert/k4dirstat"
SRC_URI="https://github.com/jeromerobert/k4dirstat/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/ki18n:5
	kde-frameworks/kiconthemes:5
	kde-frameworks/kio:5
	kde-frameworks/kjobwidgets:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kxmlgui:5
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/k4dirstat-${PV}"

src_configure() {
	local mycmakeargs=(
		-DK4DIRSTAT_GIT_VERSION=OFF
	)
	ecm_src_configure
}
