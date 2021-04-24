# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="https://apps.kde.org/multimedia https://multimedia.kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="+cdrom +ffmpeg gstreamer"

RDEPEND="
	>=kde-apps/dragon-${PV}:${SLOT}
	>=kde-apps/juk-${PV}:${SLOT}
	>=kde-apps/kdenlive-${PV}:${SLOT}
	>=kde-apps/kmix-${PV}:${SLOT}
	>=kde-apps/kwave-${PV}:${SLOT}
	>=media-sound/elisa-${PV}:${SLOT}
	cdrom? (
		>=kde-apps/audiocd-kio-${PV}:${SLOT}
		>=kde-apps/k3b-${PV}:${SLOT}
		>=kde-apps/libkcddb-${PV}:${SLOT}
		>=kde-apps/libkcompactdisc-${PV}:${SLOT}
	)
	ffmpeg? ( >=kde-apps/ffmpegthumbs-${PV}:${SLOT} )
	gstreamer? ( >=kde-apps/kamoso-${PV}:${SLOT} )
"
