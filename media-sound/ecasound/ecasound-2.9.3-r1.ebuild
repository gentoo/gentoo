# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit autotools python-single-r1

DESCRIPTION="a package for multitrack audio processing"
HOMEPAGE="https://ecasound.seul.org/ecasound/"
SRC_URI="https://ecasound.seul.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="alsa audiofile debug doc jack libsamplerate lv2 mikmod ncurses oil osc oss
python ruby sndfile static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( lv2 )
	python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="sys-libs/readline:0=
	alsa? ( media-libs/alsa-lib:= )
	audiofile? ( media-libs/audiofile:= )
	jack? ( virtual/jack:= )
	libsamplerate? ( media-libs/libsamplerate:= )
	lv2? ( media-libs/lilv:= )
	media-libs/ladspa-sdk
	mikmod? ( media-libs/libmikmod:0= )
	ncurses? ( sys-libs/ncurses:0= )
	oil? ( dev-libs/liboil:= )
	osc? ( media-libs/liblo:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:* )
	sndfile? ( media-libs/libsndfile:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
BDEPEND="sys-apps/ed"
PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${PN}-2.9.1-tinfo.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# https://bugs.gentoo.org/787620
	printf '%s\n' H '/^EXTRACXXFLAGS="-std=c++98"$/s/98/11/' w q |
		ed -s configure.ac || die "Couldn't patch EXTRACXXFLAGS in configure.ac"

	eautoreconf
}

src_configure() {
	local pyconf=()

	if use python ; then
		pyconf=( "--with-python-modules=${EPREFIX}/usr/$(get_libdir)/${EPYTHON}" )
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
		"${pyconf[@]}"
}

src_install() {
	default
	use python && python_optimize

	if use doc ; then
		dodoc Documentation/*.html
		dodoc Documentation/programmers_guide/ecasound_programmers_guide.txt
	fi

	find "${ED}" -name "*.la" -delete
}
