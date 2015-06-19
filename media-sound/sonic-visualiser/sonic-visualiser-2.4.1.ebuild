# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sonic-visualiser/sonic-visualiser-2.4.1.ebuild,v 1.2 2015/03/29 19:06:02 zlogene Exp $

EAPI=4
inherit eutils qmake-utils autotools fdo-mime

DESCRIPTION="Music audio files viewer and analiser"
HOMEPAGE="http://www.sonicvisualiser.org/"
SRC_URI="http://code.soundsoftware.ac.uk/attachments/download/1185/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="id3tag jack mad ogg osc +portaudio pulseaudio"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtxml:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	media-libs/libsndfile
	media-libs/libsamplerate
	app-arch/bzip2
	>=media-libs/dssi-0.9.1
	media-libs/liblrdf
	media-libs/ladspa-sdk
	media-libs/speex
	>=media-libs/vamp-plugin-sdk-2.0
	media-libs/rubberband
	dev-libs/sord
	dev-libs/serd
	sci-libs/fftw:3.0
	osc? ( media-libs/liblo )
	portaudio? ( >=media-libs/portaudio-19_pre20071207 )
	jack? ( media-sound/jack-audio-connection-kit )
	mad? ( media-libs/libmad )
	id3tag? ( media-libs/libid3tag )
	ogg? ( media-libs/libfishsound >=media-libs/liboggz-1.1.0 )
	pulseaudio? ( media-sound/pulseaudio )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="|| ( jack pulseaudio portaudio )"

sv_disable_opt() {
	einfo "Disabling $1"
	for i in . svapp svcore svgui ; do
		sed -i -e "/$1/d" "${S}/$i/configure.ac" || die "failed to remove $1 support"
	done
}

src_prepare() {
	use id3tag || sv_disable_opt id3tag
	use jack || sv_disable_opt jack
	use mad || sv_disable_opt mad
	use ogg || sv_disable_opt fishsound
	use ogg || sv_disable_opt oggz
	use osc || sv_disable_opt liblo
	use portaudio || sv_disable_opt portaudio
	use pulseaudio || sv_disable_opt libpulse

	eautoreconf
}

src_configure() {
	export QMAKE="$(qt5_get_bindir)"/qmake
	econf
	eqmake5 -r sonic-visualiser.pro
}

src_compile() {
	# de parallelize a bit otherwise it fails...
	emake sub-dataquay-lib-pro
	emake sub-svcore
	emake sub-svgui
	emake sub-svapp
	emake sub-sv-pro
}

src_test() {
	emake sub-svcore-base-test
	emake sub-svcore-data-fileio-test
}

src_install() {
	cd ${PN}
	dobin ${PN}
	dodoc README*
	#install samples
	insinto /usr/share/${PN}/samples
	doins samples/*
	# desktop entry
	doicon icons/sv-icon.svg
	domenu *.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
