# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="Software defined radio receiver powered by GNU Radio and Qt"
HOMEPAGE="http://gqrx.dk/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/csete/gqrx.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/csete/gqrx/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="pulseaudio"

DEPEND=">=net-wireless/gnuradio-3.7_rc:=[audio,analog,filter]
	>=net-wireless/gr-osmosdr-0.1.0:=
	dev-libs/boost:=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	pulseaudio? ( media-sound/pulseaudio:= )"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:4"

src_prepare() {
	if use !pulseaudio; then
		sed -i 's/AUDIO_BACKEND = pulse/#AUDIO_BACKEND = pulse/' gqrx.pro || die
	fi
	epatch "${FILESDIR}"/no_qtsvg.patch
	qt4-r2_src_prepare
}

src_install() {
	dobin gqrx
}
