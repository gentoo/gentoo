# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="
	https://www.kde.org/applications/multimedia/
	https://multimedia.kde.org/
"
KEYWORDS="~amd64 ~x86"
IUSE="+ffmpeg"

RDEPEND="
	$(add_kdeapps_dep audiocd-kio)
	$(add_kdeapps_dep dragon)
	$(add_kdeapps_dep juk)
	$(add_kdeapps_dep kdenlive)
	$(add_kdeapps_dep kmix)
	$(add_kdeapps_dep kscd)
	$(add_kdeapps_dep libkcddb)
	$(add_kdeapps_dep libkcompactdisc)
	ffmpeg? ( $(add_kdeapps_dep ffmpegthumbs) )
"
