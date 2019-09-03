# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_KDEINSTALLDIRS="false"
KDE_AUTODEPS="false"
inherit kde5

DESCRIPTION="Breeze theme for Plymouth"
LICENSE="GPL-2+ GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

BDEPEND="$(add_frameworks_dep extra-cmake-modules)"
DEPEND="sys-boot/plymouth"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DDISTRO_NAME="Gentoo Linux"
		-DDISTRO_VERSION=
	)

	kde5_src_configure
}
