# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/baudline/baudline-1.08-r1.ebuild,v 1.5 2015/03/10 16:07:28 xmw Exp $

EAPI=3

inherit eutils

DESCRIPTION="A time-frequency browser designed for scientific visualization of the spectral domain"
HOMEPAGE="http://www.baudline.com/"
SRC_URI="amd64? ( http://www.baudline.com/${PN}_${PV}_linux_x86_64.tar.gz )
	ppc? ( http://www.baudline.com/${PN}_${PV}_linux_ppc.tar.gz )
	s390? ( http://www.baudline.com/${PN}_${PV}_linux_s390.tar.gz )
	x86? ( http://www.baudline.com/baudline_1.08_linux_i686.tar.gz )"

LICENSE="${PN}"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="jack"

RESTRICT="mirror bindist"
QA_PREBUILT="/opt/baudline/baudline"

RDEPEND="media-fonts/font-adobe-75dpi
	media-fonts/font-misc-misc
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXxf86vm"

src_unpack() {
	unpack ${A}
	# strip arch names from S
	mv -v baudline_* ${P} || die
}

src_install() {
	insinto /opt/${PN}
	doins -r icons palettes || die

	newicon icons/spectro512.png ${PN}.png || die

	exeinto /opt/${PN}
	doexe ${PN} || die
	dosym /opt/${PN}/${PN} /usr/bin/${PN} || die
	make_desktop_entry /usr/bin/${PN} Baudline ${PN} "AudioVideo;Player;" \
		"MimeType=audio/x-aiff;audio/basic;audio/x-mp3;audio/x-flac;audio/vorbis;audio/x-wav;" \
		"audio/x-vorbis;audio/mpeg;audio/x-gsm;audio/x-voc;application/x-ogg;"

	if use jack ; then
		doexe ${PN}_jack || die
		dosym /opt/${PN}/${PN}_jack /usr/bin/${PN}_jack || die
		make_desktop_entry /usr/bin/${PN}_jack "Baudline (jack support)" ${PN} "AudioVideo;Player;" \
			"MimeType=audio/x-aiff;audio/basic;audio/x-mp3;audio/x-flac;audio/vorbis;audio/x-wav;" \
			"audio/x-vorbis;audio/mpeg;audio/x-gsm;audio/x-voc;application/x-ogg;"
	fi

	dodoc README_unix.txt || die
}
