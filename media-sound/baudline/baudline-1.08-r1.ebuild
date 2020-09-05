# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils xdg

DESCRIPTION="A time-frequency browser designed for visualization of spectral domains"
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
QA_PREBUILT="/opt/baudline/baudline*"

RDEPEND="media-fonts/font-adobe-75dpi
	media-fonts/font-misc-misc
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXxf86vm"

src_unpack() {
	default
	# strip arch names from S
	mv -v baudline_* ${P} || die
}

src_install() {
	insinto /opt/${PN}
	doins -r icons palettes

	newicon icons/spectro512.png ${PN}.png

	exeinto /opt/${PN}
	doexe ${PN}
	dosym ../../opt/${PN}/${PN} /usr/bin/${PN}
	make_desktop_entry /usr/bin/${PN} Baudline ${PN} "AudioVideo;Player;" \
		"MimeType=audio/x-aiff;audio/basic;audio/x-mp3;audio/x-flac;audio/vorbis;audio/x-wav;" \
		"audio/x-vorbis;audio/mpeg;audio/x-gsm;audio/x-voc;application/x-ogg;"

	if use jack ; then
		doexe ${PN}_jack
		dosym ../../opt/${PN}/${PN}_jack /usr/bin/${PN}_jack
		make_desktop_entry /usr/bin/${PN}_jack "Baudline (jack support)" ${PN} "AudioVideo;Player;" \
			"MimeType=audio/x-aiff;audio/basic;audio/x-mp3;audio/x-flac;audio/vorbis;audio/x-wav;" \
			"audio/x-vorbis;audio/mpeg;audio/x-gsm;audio/x-voc;application/x-ogg;"
	fi

	dodoc README_unix.txt
}
