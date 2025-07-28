# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="https://apps.kde.org/categories/multimedia/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+cdrom +ffmpeg gstreamer"

RDEPEND="
	>=kde-apps/dragon-${PV}:*
	>=kde-apps/juk-${PV}:*
	>=kde-apps/kdenlive-${PV}:*
	>=kde-apps/kmix-${PV}:*
	>=kde-apps/kwave-${PV}:*
	>=media-sound/elisa-${PV}:*
	>=media-sound/kasts-${PV}
	>=media-sound/krecorder-${PV}
	cdrom? (
		>=media-sound/audex-${PV}
		>=kde-apps/audiocd-kio-${PV}:*
		>=kde-apps/k3b-${PV}:*
		>=kde-apps/libkcddb-${PV}:*
		>=kde-apps/libkcompactdisc-${PV}:*
	)
	ffmpeg? ( >=kde-apps/ffmpegthumbs-${PV}:* )
	gstreamer? ( >=kde-apps/kamoso-25.07.70:* )
"
