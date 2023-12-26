# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multibuild toolchain-funcs xdg

DESCRIPTION="Versatile Commodore Emulator"
HOMEPAGE="https://vice-emu.sourceforge.io/"
SRC_URI="mirror://sourceforge/vice-emu/releases/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="
	alsa curl debug doc ethernet flac gif +gtk headless lame mpg123
	ogg openmp oss parport pci png portaudio pulseaudio sdl
"
REQUIRED_USE="|| ( gtk headless sdl )"

RDEPEND="
	sys-libs/zlib:=
	virtual/libintl
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	ethernet? (
		net-libs/libpcap
		sys-libs/libcap
	)
	flac? ( media-libs/flac:= )
	gif? ( media-libs/giflib:= )
	gtk? (
		>=app-accessibility/at-spi2-core-2.46:2
		dev-libs/glib:2
		media-libs/fontconfig:1.0
		media-libs/glew:0=[-egl-only(-)]
		media-libs/libglvnd[X]
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[X]
		x11-libs/libX11
		x11-libs/pango
	)
	lame? ( media-sound/lame )
	mpg123? ( || ( media-libs/libmpg123 <media-sound/mpg123-1.32.3-r1 ) )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	parport? ( sys-libs/libieee1284 )
	pci? ( sys-apps/pciutils )
	png? ( media-libs/libpng:= )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	sdl? (
		media-libs/libsdl2[video]
		media-libs/sdl2-image
	)
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-alternatives/awk
	app-alternatives/yacc
	app-arch/unzip
	app-text/dos2unix
	dev-embedded/xa
	dev-lang/perl
	sys-apps/texinfo
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( virtual/texi2dvi )
	gtk? ( x11-misc/xdg-utils )
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

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
	(( ${#MULTIBUILD_VARIANTS[@]} > 1 )) &&
		xform="/^x/s/\$/.${MULTIBUILD_VARIANT}/"

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
		$(vice-multi_enable gtk gtk3ui)
		$(vice-multi_enable headless headlessui)
		$(vice-multi_enable sdl sdl2ui)
		$(usex debug $(vice-multi_enable gtk debug-gtk3ui) --disable-debug-gtk3ui)
		$(use_enable debug)
		$(use_enable doc pdf-docs)
		$(use_enable ethernet)
		$(use_enable openmp)
		$(use_enable parport parsid)
		$(use_with alsa)
		$(use_with curl libcurl)
		$(use_with flac)
		$(use_with gif)
		$(use_with lame)
		$(use_with lame static-lame) # disables dlopen, uses shared still
		$(use_with mpg123)
		$(use_with ogg vorbis)
		$(use_with oss)
		$(use_with parport libieee1284)
		$(use_with png)
		$(use_with portaudio)
		$(use_with pulseaudio pulse)
		$(usex alsa --enable-midi $(use_enable oss midi))
		$(usev !pci ac_cv_header_pci_pci_h=no)
		--disable-arch
		--disable-ffmpeg # deprecated in 3.8, also bug #834359
		--disable-sdl1ui
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

	vice-install_extras() {
		docinto html
		dodoc doc/html/*.{html,css}
		dodoc -r doc/html/images

		insinto /usr/share/vim/vimfiles/ftdetect
		doins doc/vim/ftdetect/*.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins doc/vim/syntax/*.vim
	}
	multibuild_for_best_variant run_in_build_dir vice-install_extras
}
