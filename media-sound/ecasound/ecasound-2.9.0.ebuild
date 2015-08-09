# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="python? 2"

inherit eutils python autotools

DESCRIPTION="a package for multitrack audio processing"
HOMEPAGE="http://ecasound.seul.org/ecasound"
SRC_URI="http://ecasound.seul.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="alsa audiofile debug doc jack libsamplerate lv2 mikmod ncurses oil osc oss
python ruby sndfile static-libs test"
REQUIRED_USE="test? ( lv2 )"

RDEPEND="sys-libs/readline
	alsa? ( media-libs/alsa-lib )
	audiofile? ( media-libs/audiofile )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	lv2? ( >=media-libs/lilv-0.5.0 )
	media-libs/ladspa-sdk
	mikmod? ( media-libs/libmikmod:0 )
	ncurses? ( sys-libs/ncurses )
	oil? ( dev-libs/liboil )
	osc? ( media-libs/liblo )
	ruby? ( dev-lang/ruby )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if use python ; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.8.1-ldflags.patch

	if use python ; then
		sed -i -e "s:\$(ecasoundc_libs):\0 $(python_get_library -l):" \
			pyecasound/Makefile.am || die "sed failed"
	fi

	eautoreconf
}

src_configure() {
	local pyconf

	if use python ; then
		pyconf="--with-python-includes=${EPREFIX}$(python_get_includedir)
			--with-python-modules=${EPREFIX}$(python_get_libdir)"
	fi

	econf \
		--disable-arts \
		--enable-shared \
		--enable-sys-readline \
		--with-largefile \
		$(use_enable alsa) \
		$(use_enable audiofile) \
		$(use_enable debug) \
		$(use_enable jack) \
		$(use_enable libsamplerate) \
		$(use_enable lv2 liblilv) \
		$(use_enable ncurses) \
		$(use_enable oil liboil) \
		$(use_enable osc liblo) \
		$(use_enable oss) \
		$(use_enable python pyecasound) \
		$(use_enable ruby rubyecasound) \
		$(use_enable sndfile) \
		$(use_enable static-libs static) \
		${pyconf}
}

src_install() {
	default

	if use doc ; then
		dohtml Documentation/*.html
		dodoc Documentation/programmers_guide/ecasound_programmers_guide.txt
	fi

	prune_libtool_files
}

pkg_postinst() {
	use python && python_mod_optimize ecacontrol.py eci.py pyeca.py
}

pkg_postrm() {
	use python && python_mod_cleanup ecacontrol.py eci.py pyeca.py
}
