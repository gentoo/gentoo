# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="a package for multitrack audio processing"
HOMEPAGE="https://ecasound.seul.org/ecasound/"
SRC_URI="https://${PN}.seul.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa audiofile debug doc jack libsamplerate mikmod ncurses vorbis oss python ruby sndfile"

RDEPEND="python? ( ${PYTHON_DEPS} )
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

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local pyconf=()

	if use python ; then
		pyconf=( "--with-python-modules=${EPREFIX}/usr/$(get_libdir)/${EPYTHON}" )
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
		$(use_enable python pyecasound c) \
		$(use_enable ruby rubyecasound) \
		$(use_enable sndfile) \
		--enable-shared \
		--with-largefile \
		--enable-sys-readline \
		"${pyconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	use python && python_optimize
	dodoc BUGS NEWS README TODO
	use doc && dodoc Documentation/*.html
}
