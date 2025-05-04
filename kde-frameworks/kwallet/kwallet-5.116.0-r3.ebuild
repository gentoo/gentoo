# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Interface to KWallet Framework providing desktop-wide storage for passwords"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${P}-patchset.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="minimal"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kconfig-${KDE_CATV}*:5
"
RDEPEND="${DEPEND}
	!minimal? ( kde-frameworks/kwallet:6 )
"

PATCHES=( "${WORKDIR}/${P}-patchset" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_KWALLETD=OFF
		-DBUILD_KWALLET_QUERY=OFF
	)
	ecm_src_configure
}
