# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A software synthesizer plugin for the DSSI Soft Synth Interface"
HOMEPAGE="http://dssi.sourceforge.net/download.html#Xsynth-DSSI"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	media-libs/alsa-lib
	>=media-libs/dssi-0.9
	>=media-libs/liblo-0.12
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
	virtual/pkgconfig"
