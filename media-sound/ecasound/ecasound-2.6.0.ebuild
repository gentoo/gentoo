# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils python

DESCRIPTION="a package for multitrack audio processing"
HOMEPAGE="http://ecasound.seul.org/ecasound"
SRC_URI="http://${PN}.seul.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa audiofile debug doc jack libsamplerate mikmod ncurses vorbis oss python ruby sndfile"

RDEPEND="python? ( dev-lang/python )
	jack? ( media-sound/jack-audio-connection-kit )
	media-libs/ladspa-sdk
	audiofile? ( media-libs/audiofile )
	alsa? ( media-libs/alsa-lib )
	vorbis? ( media-libs/libvorbis )
	libsamplerate? ( media-libs/libsamplerate )
	mikmod? ( media-libs/libmikmod:0 )
	ruby? ( dev-lang/ruby )
	python? ( dev-lang/python )
	ncurses? ( sys-libs/ncurses )
	sndfile? ( media-libs/libsndfile )
	sys-libs/readline"
DEPEND="${RDEPEND}"

src_configure() {
	local PYConf

	if use python; then
		PYConf="--enable-pyecasound=c
			--with-python-includes=$(python_get_includedir)
			--with-python-modules=$(python_get_libdir)"
	else
		PYConf="$myconf --disable-pyecasound"
	fi

	econf \
		$(use_enable alsa) \
		--disable-arts \
		$(use_enable audiofile) \
		$(use_enable debug) \
		$(use_enable jack) \
		$(use_enable libsamplerate) \
		$(use_enable ncurses) \
		$(use_enable oss) \
		$(use_enable ruby rubyecasound) \
		$(use_enable sndfile) \
		--enable-shared \
		--with-largefile \
		--enable-sys-readline \
		${PYConf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc BUGS NEWS README TODO Documentation/*.txt
	use doc && dohtml Documentation/*.html
}

pkg_postinst() {
	if use python; then
		python_mod_optimize ecacontrol.py eci.py pyeca.py
	fi
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup ecacontrol.py eci.py pyeca.py
	fi
}
