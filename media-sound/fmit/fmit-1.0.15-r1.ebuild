# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

DESCRIPTION="Free Music Instrument Tuner"
HOMEPAGE="https://gillesdegottex.github.io/fmit"
SRC_URI="https://github.com/gillesdegottex/fmit/archive/v${PV}.tar.gz \
							-> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack oss portaudio"

RDEPEND=">=sci-libs/fftw-3.3.4:3.0=
	dev-qt/qtmultimedia:5
	dev-qt/qtopengl:5
	dev-qt/qtsvg:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[-gles2]
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( media-libs/portaudio )"

DEPEND="${RDEPEND}
	dev-qt/linguist-tools"

src_prepare() {
	# Fix the path to readme file to prevent errors on start up
	sed -i "/QFile readmefile/c\QFile readmefile \
		(\"/usr/share/doc/${PF}/README.txt\");" \
		src/main.cpp || die "README sed failed"
	# Fix the PREFIX location, insert real path.
	sed -i "/QString fmitprefix/c\QString fmitprefix(STR(/usr));" \
		src/main.cpp || die "PREFIX fix sed failed"
	# Fix the PREFIX location, insert real path.
	sed -i "/QString fmitprefix/c\QString fmitprefix(STR(/usr));" \
		src/modules/MicrotonalView.cpp || die "PREFIX fix sed failed"
	default
}

src_configure() {
	local config flag
	for flag in alsa jack portaudio oss; do
		use ${flag} && config+=" acs_${flag}"
	done

	"$(qt5_get_bindir)"/lrelease fmit.pro || die "Running lrelease failed"

	eqmake5 CONFIG+="${config}" fmit.pro PREFIX="${D}"/usr \
		PREFIXSHORTCUT="${D}"/usr DISTDIR=/usr
}
