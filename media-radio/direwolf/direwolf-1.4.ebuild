# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd

DESCRIPTION="Decoded Information from Radio Emissions for Windows Or Linux Fans"
HOMEPAGE="https://github.com/wb2osz/direwolf/blob/master/README.md"
SRC_URI="https://github.com/wb2osz/direwolf/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib:="
DEPEND="${RDEPEND}"

DOCS=( CHANGES.md README.md doc/2400-4800-PSK-for-APRS-Packet-Radio.pdf doc/A-Better-APRS-Packet-Demodulator-Part-1-1200-baud.pdf doc/A-Better-APRS-Packet-Demodulator-Part-2-9600-baud.pdf doc/A-Closer-Look-at-the-WA8LMF-TNC-Test-CD.pdf doc/APRS-Telemetry-Toolkit.pdf doc/APRStt-Implementation-Notes.pdf doc/APRStt-interface-for-SARTrack.pdf doc/APRStt-Listening-Example.pdf doc/Going-beyond-9600-baud.pdf doc/Raspberry-Pi-APRS.pdf doc/Raspberry-Pi-APRS-Tracker.pdf doc/Raspberry-Pi-SDR-IGate.pdf doc/README.md doc/Successful-APRS-IGate-Operation.pdf doc/User-Guide.pdf doc/WA8LMF-TNC-Test-CD-Results.pdf direwolf.conf dw-start.sh sdr.conf telemetry-toolkit/telem-m0xer-3.txt telemetry-toolkit/telem-balloon.conf telemetry-toolkit/telem-volts.conf )

INSTALLDIR="${D}"

src_prepare() {
	eapply_user
	epatch "${FILESDIR}/${PV}-makefile.patch"
}

src_install() {
	dodir /usr
	dodir /usr/bin
	dodir /var/log/direwolf
	emake DESTDIR="${D}" install
	insinto /etc/direwolf/
	doins direwolf.conf
	einstalldocs
	systemd_dounit "${FILESDIR}"/direwolf.service
	systemd_dounit "${FILESDIR}"/direwolf-kiss.service
}
