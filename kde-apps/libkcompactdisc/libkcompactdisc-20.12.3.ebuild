# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KFMIN=5.75.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Library for playing & ripping CDs"

LICENSE="GPL-2+ LGPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="alsa"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=media-libs/phonon-4.11.0
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package alsa ALSA)
	)
	ecm_src_configure
}
