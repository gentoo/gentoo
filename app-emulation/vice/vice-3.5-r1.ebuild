# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multibuild toolchain-funcs xdg

DESCRIPTION="The Versatile Commodore Emulator"
HOMEPAGE="https://vice-emu.sourceforge.io/"
SRC_URI="mirror://sourceforge/vice-emu/releases/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="
	alsa cpuhistory debug doc ethernet ffmpeg flac gif +gtk headless jpeg
	lame mpg123 ogg oss parport pci png portaudio pulseaudio sdl zlib"
REQUIRED_USE="
	|| ( gtk headless sdl )
	gtk? ( zlib )"

RDEPEND="
	sys-libs/readline:=
	virtual/libintl
	alsa? ( media-libs/alsa-lib )
	ethernet? (
		net-libs/libnet:1.1
		net-libs/libpcap
	)
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac )
	gif? ( media-libs/giflib:= )
	gtk? (
		dev-libs/atk
		dev-libs/glib:2
		media-libs/fontconfig:1.0
		media-libs/glew:0=
		virtual/opengl
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[X]
		x11-libs/libX11
		x11-libs/pango
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
	png? ( media-libs/libpng:= )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? (
		media-libs/libsdl2[video]
		media-libs/sdl2-image
	)
	zlib? ( sys-libs/zlib:= )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
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
	gtk? ( x11-misc/xdg-utils )"

src_prepare() {
	default

	# Delete some bundled libraries.
	rm -r src/lib/lib{ffmpeg,lame,x264} || die

	# Strip the predefined C(XX)FLAGS.
	sed -i -r 's:(VICE_C(XX)?FLAGS=)"[^$]+":\1:' configure || die

	MULTIBUILD_VARIANTS=(
		$(usev gtk)
		$(usev headless)
		$(usev sdl)
	)

	# Debug build currently broken without copy sources.
	multibuild_copy_sources
}

src_configure() {
	tc-export AR

	multibuild_foreach_variant run_in_build_dir multibuild_src_configure
}

multibuild_src_configure() {
	# Append ".variant" to x* programs if building multiple variants.
	local xform
	if [[ ${#MULTIBUILD_VARIANTS[@]} -gt 1 ]]; then
		xform="/^x/s/\$/.${MULTIBUILD_VARIANT}/"
	fi

	vice-multi_enable() {
		if [[ ${MULTIBUILD_VARIANT} == ${1} ]]; then
			echo --enable-${2}
		else
			echo --disable-${2}
		fi
	}

	local econfargs=(
		--program-transform-name="${xform}"
		$(vice-multi_enable gtk desktop-files)
		$(vice-multi_enable gtk native-gtk3ui)
		$(vice-multi_enable headless headlessui)
		$(vice-multi_enable sdl sdlui2)
		$(use_enable cpuhistory)
		$(use_enable debug debug-gtk3ui)
		$(use_enable debug)
		$(use_enable doc pdf-docs)
		$(use_enable ethernet)
		$(use_enable ffmpeg external-ffmpeg)
		$(use_enable lame)
		$(use_enable parport libieee1284)
		$(use_enable portaudio)
		$(use_with alsa)
		$(use_with flac)
		$(use_with gif)
		$(use_with jpeg)
		$(use_with mpg123)
		$(use_with ogg vorbis)
		$(use_with oss)
		$(use_with png)
		$(use_with pulseaudio pulse)
		$(use_with zlib)
		$(usex alsa --enable-midi $(use_enable oss midi))
		$(usex pci '' ac_cv_header_pci_pci_h=no)
		--disable-arch
		--disable-sdlui
		--disable-shared-ffmpeg
		--disable-static-ffmpeg
		--disable-static-lame
		--enable-html-docs
		--enable-ipv6
		ac_cv_lib_ungif_EGifPutLine=no # ensure use giflib, not ungif
	)

	econf "${econfargs[@]}"
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

	# Delete the bundled fonts. These could be packaged separately but
	# they're only for the HTML documentation.
	rm -r "${ED}"/usr/share/doc/${PF}/html/fonts || die
}
