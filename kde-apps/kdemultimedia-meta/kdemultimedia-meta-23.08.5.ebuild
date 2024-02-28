# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="https://apps.kde.org/categories/multimedia/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+cdrom +ffmpeg gstreamer"

RDEPEND="
	>=kde-apps/dragon-${PV}:5
	>=kde-apps/juk-${PV}:5
	>=kde-apps/kdenlive-${PV}:5
	>=kde-apps/kmix-${PV}:5
	>=kde-apps/kwave-${PV}:5
	>=media-sound/elisa-${PV}:5
	>=media-sound/kasts-${PV}
	>=media-sound/krecorder-${PV}
	cdrom? (
		>=kde-apps/audiocd-kio-${PV}:5
		>=kde-apps/k3b-${PV}:5
		>=kde-apps/libkcddb-${PV}:5
		>=kde-apps/libkcompactdisc-${PV}:5
	)
	ffmpeg? ( >=kde-apps/ffmpegthumbs-${PV}:5 )
	gstreamer? ( >=kde-apps/kamoso-${PV}:5 )
"
