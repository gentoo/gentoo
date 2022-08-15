# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Scriptable DVD copy software"
HOMEPAGE="http://dvdshrink.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P/_p/-}mdk.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk"

RDEPEND="
	app-cdr/cdrtools
	>=app-cdr/dvd+rw-tools-6.1
	>=app-text/gocr-0.40
	>=media-video/dvdauthor-0.6.11
	>=media-video/mjpegtools-1.8.0-r1
	>=media-video/subtitleripper-0.3.4-r1
	>=media-video/transcode-1.0.2-r2[dvd]
	gtk? ( >=dev-perl/Gtk2-1.104 )"

PATCHES=( "${FILESDIR}"/${PN}-2.6.1_p10-fix-paths.patch )

src_install() {
	dobin usr/bin/{batchrip.sh,dvds{functions,hrink}}

	use gtk && dobin usr/bin/xdvdshrink.pl

	insinto /usr/share
	doins -r usr/share/applications/dvdshrink

	dodoc usr/share/doc/dvdshrink/{batchrip.txt,example.xml,README.txt}

	doicon usr/share/icons/{batchrip.xpm,dvdshrink.xpm}
	use gtk && make_desktop_entry xdvdshrink.pl xDVDShrink ${PN} AudioVideo
}
