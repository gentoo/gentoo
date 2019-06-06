# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Library for playing & ripping CDs"
LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="alsa"

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	media-libs/phonon[qt5(+)]
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package alsa ALSA)
	)
	kde5_src_configure
}
