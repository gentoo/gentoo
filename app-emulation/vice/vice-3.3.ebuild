# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="the Versatile Commodore Emulator"
HOMEPAGE="http://vice-emu.sourceforge.net/"
SRC_URI="mirror://sourceforge/vice-emu/releases/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa ethernet ffmpeg +gtk ipv6 lame libav nls oss png pulseaudio threads vte zlib"

REQUIRED_USE="gtk"

RDEPEND="
	media-libs/giflib
	virtual/jpeg:0
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	ethernet? (
	    >=net-libs/libpcap-0.9.8
	    >=net-libs/libnet-1.1.2.1:1.1
	)
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:= )
	)
	lame? ( media-sound/lame )
	nls? ( virtual/libintl )
	png? ( media-libs/libpng:0= )
	pulseaudio? ( media-sound/pulseaudio )
	zlib? ( sys-libs/zlib )
"

DEPEND="${RDEPEND}
	dev-embedded/xa
	media-libs/fontconfig
	x11-apps/bdftopcf
	x11-apps/mkfontdir
	nls? ( sys-devel/gettext )
"

BDEPEND="
	x11-base/xorg-proto
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i \
		-e 's/building//' \
		doc/Makefile.am || die
	sed -i \
		-e "/^docdir =/s:=.*:=/usr/share/doc/${PF}:" \
		doc/Makefile.am \
		doc/readmes/Makefile.am || die
	sed -i \
		-e "/^docdir =/s:=.*:=/usr/share/doc/${PF}/html:" \
		doc/html/Makefile.am || die
	sed -i \
		-e "s:/usr/local/lib/VICE:/usr/$(get_libdir)/${PN}:" \
		man/vice.1 \
		$(grep -rl --exclude="*texi" /usr/local/lib doc) || die
	sed -i \
		-e "/VICEDIR=/s:=.*:=\"/usr/$(get_libdir)/${PN}\";:" \
		configure.ac || die
	sed -i \
		-e "s:\(#define LIBDIR \).*:\1\"/usr/$(get_libdir)/${PN}\":" \
		-e "s:\(#define DOCDIR \).*:\1\"/usr/share/doc/${PF}\":" \
		src/arch/gtk3/archdep_unix.h || die
	rm -rf src/lib/{libffmpeg,liblame} || die
	sed -i \
		-e '/SUBDIRS/s/libffmpeg//;' \
		-e '/SUBDIRS/s/liblame//;' \
		src/lib/Makefile.am || die
	AT_NO_RECURSIVE=1 eautoreconf
}

src_configure() {
	local gui_arg=() snd_arg=()

	snd_arg+=( $(use_with alsa) )
	snd_arg+=( $(use_with oss) )
	snd_arg+=( $(use_with pulseaudio pulse) )

	# --with-readline is forced to avoid using the embedded copy
	# don't try to actually run fc-cache (bug #280976)
	FCCACHE=/bin/true \
	PKG_CONFIG=$(tc-getPKG_CONFIG) \
	econf \
		--enable-parsid \
		--with-resid \
		--with-readline \
		--without-arts \
		--without-midas \
		$(use_enable ethernet) \
		$(use_enable ffmpeg) \
		$(use_enable ffmpeg external-ffmpeg) \
		$(use_enable ipv6) \
		$(use_enable lame) \
		$(use_enable nls) \
		$(use_enable vte) \
		$(use_with png) \
		$(use_with threads uithreads) \
		$(use_with zlib) \
		"${gui_arg[@]}" \
		"${snd_arg[@]}" \
		--enable-native-gtk3ui \
		--disable-option-checking
		# --disable-option-checking has to be last
}

src_install() {
	default
	dodoc FEEDBACK
}
