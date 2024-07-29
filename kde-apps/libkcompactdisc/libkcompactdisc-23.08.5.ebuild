# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Library for playing & ripping CDs"

LICENSE="GPL-2+ LGPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="alsa kf6compat"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=media-libs/phonon-4.11.0[qt5(+)]
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}
	kf6compat? ( kde-apps/libkcompactdisc:6 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package alsa ALSA)
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install

	if use kf6compat; then
		rm -r "${D}"/usr/share/locale || die
	fi
}
