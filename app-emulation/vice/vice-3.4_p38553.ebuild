# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multibuild xdg

MY_P="vice-emu-code-r${PV##*_p}-trunk-vice"

DESCRIPTION="The Versatile Commodore Emulator"
HOMEPAGE="https://vice-emu.sourceforge.io/"
#SRC_URI="mirror://sourceforge/vice-emu/releases/${P}.tar.gz"
SRC_URI="https://sourceforge.net/code-snapshots/svn/v/vi/vice-emu/code/${MY_P}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa debug doc ethernet ffmpeg flac gif +gtk headless ipv6 jpeg lame mpg123 ogg oss +opengl parport pci png portaudio pulseaudio sdl zlib"
REQUIRED_USE="|| ( gtk headless sdl ) gtk? ( zlib )"

RDEPEND="
	sys-libs/readline:0=
	virtual/libintl
	alsa? ( media-libs/alsa-lib )
	ethernet? (
		>=net-libs/libpcap-0.9.8
		>=net-libs/libnet-1.1.2.1:1.1
	)
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac )
	gif? ( media-libs/giflib:= )
	gtk? (
		dev-libs/glib:2
		media-libs/fontconfig:1.0
		x11-libs/cairo
		x11-libs/gtk+:3
		x11-libs/pango
		opengl? (
			media-libs/glew:0=
			virtual/opengl
		)
	)
	jpeg? ( virtual/jpeg )
	lame? ( media-sound/lame )
	mpg123? ( media-sound/mpg123 )
	ogg? (
		 media-libs/libogg
		 media-libs/libvorbis
	)
	parport? ( sys-libs/libieee1284 )
	pci? ( sys-apps/pciutils )
	png? ( media-libs/libpng:0= )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl2[video] )
	zlib? ( sys-libs/zlib )
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

BDEPEND="
	app-arch/unzip
	app-text/dos2unix
	dev-embedded/xa
	dev-lang/perl
	sys-apps/texinfo
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	virtual/yacc
	doc? ( virtual/texi2dvi )
	gtk? ( x11-misc/xdg-utils )
"

S="${WORKDIR}/${MY_P}"
ECONF_SOURCE="${S}"

PATCHES=(
	"${FILESDIR}"/vice-pkg-config-${PV}.patch
)

src_prepare() {
	default

	# Delete some bundled libraries.
	rm -r src/lib/lib{ffmpeg,lame,x264} || die

	local DIR
	for DIR in src/resid src/resid-dtv .; do
		pushd "${DIR}" || die
		AT_NO_RECURSIVE=1 eautoreconf
		popd || die
	done

	# Strip the predefined C(XX)FLAGS.
	sed -i -r 's:(VICE_C(XX)?FLAGS=)"[^$]+":\1:' configure || die
}

src_configure() {
	MULTIBUILD_VARIANTS=(
		$(usev gtk)
		$(usev headless)
		$(usev sdl)
	)

	multibuild_foreach_variant run_in_build_dir multibuild_src_configure
}

multibuild_enable() {
	if [[ ${MULTIBUILD_VARIANT} == $1 ]]; then
		printf -- "--enable-%s\n" "$2"
	else
		printf -- "--disable-%s\n" "$2"
	fi
}

multibuild_src_configure() {
	# Some dependencies lack configure options so prevent them becoming
	# automagic by using configure cache variables.
	use pci || export ac_cv_header_pci_pci_h=no

	# Ensure we use giflib, not ungif.
	export ac_cv_lib_ungif_EGifPutLine=no

	# Append ".variant" to x* programs if building multiple variants.
	if [[ ${#MULTIBUILD_VARIANTS[@]} -gt 1 ]]; then
		xform="/^x/s/\$/.${MULTIBUILD_VARIANT}/"
	else
		unset xform
	fi

	econf \
		--program-transform-name="${xform}" \
		--disable-arch \
		$(use_enable debug) \
		$(use_enable debug debug-gtk3ui) \
		$(use_enable ffmpeg external-ffmpeg) \
		$(multibuild_enable headless headlessui) \
		--enable-html-docs \
		$(use_enable ethernet) \
		$(use_enable opengl hwscale) \
		$(use_enable ipv6) \
		$(use_enable lame) \
		$(use_enable parport libieee1284) \
		$(multibuild_enable gtk native-gtk3ui) \
		$(use_enable doc pdf-docs) \
		$(use_enable portaudio) \
		--disable-sdlui \
		$(multibuild_enable sdl sdlui2) \
		--disable-shared-ffmpeg \
		--disable-static-ffmpeg \
		$(multibuild_enable gtk desktop-files) \
		$(use_with alsa) \
		$(use_with gif) \
		$(use_with jpeg) \
		$(use_with oss) \
		$(use_with png) \
		$(use_with pulseaudio pulse) \
		$(use_with zlib) \
		$(use_with mpg123) \
		$(use_with ogg vorbis) \
		$(use_with flac)
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir emake
}

src_install() {
	# Get xdg-desktop-menu to play nicely while doing the install.
	dodir /etc/xdg/menus /usr/share/{applications,desktop-directories}
	XDG_UTILS_INSTALL_MODE=system \
	XDG_DATA_DIRS="${ED}"/usr/share \
	XDG_CONFIG_DIRS="${ED}"/etc/xdg \
		multibuild_foreach_variant run_in_build_dir default
	rm -f "${ED}"/usr/share/applications/*.cache || die
	dodoc FEEDBACK

	# Delete the bundled fonts. These could be packaged separately but
	# they're only for the HTML documentation.
	rm -r "${ED}"/usr/share/doc/${PF}/html/fonts/ || die
}
