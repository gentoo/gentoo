# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Library for playing & ripping CDs"

LICENSE="GPL-2+ LGPL-2+"
SLOT="6"
KEYWORDS="~amd64"
IUSE="alsa"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=media-libs/phonon-4.12.0[qt6]
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package alsa ALSA)
	)
	ecm_src_configure
}
