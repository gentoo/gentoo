# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Interface to KWallet Framework providing desktop-wide storage for passwords"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="minimal"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kconfig-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}"
PDEPEND="!minimal? ( =kde-frameworks/kwallet-runtime-${KDE_CATV}* )"

PATCHES=( "${FILESDIR}/${PN}-6.14.0-deps.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_KSECRETD=OFF
		-DBUILD_KWALLETD=OFF
		-DBUILD_KWALLET_QUERY=OFF
	)
	ecm_src_configure
}
