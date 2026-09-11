# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCHSET="${P}-patchset-1"
QTMIN=6.10.1
inherit ecm frameworks.kde.org

DESCRIPTION="Interface to KWallet Framework providing desktop-wide storage for passwords"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/kde/${PATCHSET}.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="minimal"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kconfig-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}"
PDEPEND="!minimal? ( =kde-frameworks/kwallet-runtime-${KDE_CATV}* )"

PATCHES=( "${WORKDIR}/${PATCHSET}" ) # in 6.30

src_configure() {
	local mycmakeargs=(
		-DBUILD_KSECRETD=OFF
		-DBUILD_KWALLETD=OFF
		-DBUILD_KWALLET_QUERY=OFF
	)
	ecm_src_configure
}
