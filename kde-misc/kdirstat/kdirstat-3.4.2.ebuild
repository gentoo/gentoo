# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="k4dirstat-${PV}"
ECM_HANDBOOK="forceoptional"
inherit ecm

DESCRIPTION="GUI equivalent to the du command based on KDE Frameworks"
HOMEPAGE="https://github.com/jeromerobert/k4dirstat"
SRC_URI="https://github.com/jeromerobert/k4dirstat/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="5"
<<<<<<< HEAD
KEYWORDS="amd64 ~arm64 x86"
=======
KEYWORDS="amd64 ~arm64 ~x86"
>>>>>>> 3928948a06b (rebase)
IUSE=""

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
BDEPEND="sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		-DK4DIRSTAT_GIT_VERSION=OFF
	)
	ecm_src_configure
}
