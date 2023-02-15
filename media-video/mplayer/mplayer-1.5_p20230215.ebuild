# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs flag-o-matic

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.ffmpeg.org/ffmpeg.git"
	ESVN_REPO_URI="svn://svn.mplayerhq.hu/mplayer/trunk"
	RELEASE_URI=""

	inherit subversion git-r3
elif [[ "${PV%_rc*}" == "${PV}" && "${PV%_pre*}" == "${PV}" && "${PV%_p*}" == "${PV}" ]]; then
	MY_P="MPlayer-${PV}"
	S="${WORKDIR}/${MY_P}"
	RELEASE_URI="mirror://mplayer/releases/${MY_P}.tar.xz"
else
	# If necessary, don't be afraid to make a snapshot.
	# http://www.mplayerhq.hu/design7/dload.html says:
	# "We recommend to always use the latest SVN to get the all the new
	# features and bugfixes, especially if the release date above looks old."
	RELEASE_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"
fi

FONT_URI="
	mirror://mplayer/releases/fonts/font-arial-iso-8859-1.tar.bz2
	mirror://mplayer/releases/fonts/font-arial-iso-8859-2.tar.bz2
	mirror://mplayer/releases/fonts/font-arial-cp1250.tar.bz2
"

DESCRIPTION="Media Player for Linux"
HOMEPAGE="http://www.mplayerhq.hu/"
SRC_URI="
	${RELEASE_URI}
	!truetype? ( ${FONT_URI} )
"

IUSE="cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_fma3 cpu_flags_x86_fma4"
IUSE+=" cpu_flags_x86_mmx cpu_flags_x86_mmxext"
IUSE+=" cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1"
IUSE+=" cpu_flags_x86_sse4_2 cpu_flags_x86_xop"
IUSE+=" cpu_flags_x86_3dnow cpu_flags_x86_3dnowext"

IUSE+=" cpu_flags_ppc_altivec"

IUSE+=" a52 aalib +alsa aqua bidi bl bluray"
IUSE+=" bs2b cddb +cdio cdparanoia cpudetection debug dga doc dts dv dvb +dvd +dvdnav +enca +encode faac faad fbcon"
IUSE+=" ftp ggi gsm +iconv ipv6 jack joystick jpeg ladspa +libass libcaca libmpeg2 lirc live lzo mad md5sum"
IUSE+=" mng mp3 nas +network openal opengl +osdmenu oss png pnm pulseaudio pvr"
IUSE+=" radio rar rtc rtmp samba selinux +shm sdl speex"
IUSE+=" tga theora tremor +truetype toolame twolame +unicode v4l vcd vdpau vidix"
IUSE+=" vorbis +X x264 xinerama +xscreensaver +xv xvid yuv4mpeg zoran"

VIDEO_CARDS="mga"
for x in ${VIDEO_CARDS}; do
	IUSE+=" video_cards_${x}"
done

FONT_RDEPS="
	media-libs/fontconfig
	>=media-libs/freetype-2.2.1:2
	virtual/ttf-fonts
"
X_RDEPS="
	x11-libs/libXext
	x11-libs/libXxf86vm
"
# - RAR: although -gpl version is nice, it can't do most functions normal rars can
#	nemesi? ( net-libs/libnemesi )
# - mplayer relies on private APIs in giflib that have been removed:
#   https://sourceforge.net/p/giflib/bugs/132/
RDEPEND="
	app-arch/bzip2
	>=media-video/ffmpeg-4.0:=[vdpau?]
	sys-libs/ncurses:=
	sys-libs/zlib
	a52? ( media-libs/a52dec )
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	bidi? ( dev-libs/fribidi )
	bluray? ( >=media-libs/libbluray-0.2.1:= )
	bs2b? ( media-libs/libbs2b )
	cdio? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia
	)
	cdparanoia? ( !cdio? ( media-sound/cdparanoia ) )
	dga? ( x11-libs/libXxf86dga )
	dts? ( media-libs/libdca )
	dv? ( media-libs/libdv )
	dvd? ( >=media-libs/libdvdread-4.1.3:= )
	dvdnav? ( >=media-libs/libdvdnav-4.1.3:= )
	encode? (
		!twolame? ( toolame? ( media-sound/toolame ) )
		twolame? ( media-sound/twolame )
		faac? ( media-libs/faac )
		mp3? ( media-sound/lame )
		x264? ( >=media-libs/x264-0.0.20100423:= )
		xvid? ( media-libs/xvid )
	)
	enca? ( app-i18n/enca )
	faad? ( media-libs/faad2 )
	ggi? ( media-libs/libggi media-libs/libggiwmh )
	gsm? ( media-sound/gsm )
	iconv? ( virtual/libiconv )
	jack? ( virtual/jack )
	jpeg? ( media-libs/libjpeg-turbo:= )
	ladspa? ( media-libs/ladspa-sdk )
	libass? ( >=media-libs/libass-0.9.10:= )
	libcaca? ( media-libs/libcaca )
	libmpeg2? ( media-libs/libmpeg2 )
	lirc? ( app-misc/lirc )
	live? ( media-plugins/live )
	lzo? ( >=dev-libs/lzo-2 )
	mad? ( media-libs/libmad )
	mng? ( media-libs/libmng:= )
	mp3? ( media-sound/mpg123 )
	nas? ( media-libs/nas )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:= )
	pnm? ( media-libs/netpbm )
	pulseaudio? ( media-sound/pulseaudio )
	rar? (
		|| (
			app-arch/unrar
			app-arch/rar
		)
	)
	rtmp? ( media-video/rtmpdump )
	samba? ( net-fs/samba )
	sdl? ( media-libs/libsdl )
	speex? ( media-libs/speex )
	theora? ( media-libs/libtheora[encode?] )
	tremor? ( media-libs/tremor )
	truetype? ( ${FONT_RDEPS} )
	vdpau? ( x11-libs/libvdpau )
	vorbis? ( !tremor? ( media-libs/libvorbis ) )
	X? ( ${X_RDEPS}	)
	xinerama? ( x11-libs/libXinerama )
	xscreensaver? ( x11-libs/libXScrnSaver )
	xv? ( x11-libs/libXv )
"
DEPEND="
	${RDEPEND}
	dga? ( x11-base/xorg-proto )
	dvb? ( virtual/linuxtv-dvb-headers )
	X? ( x11-base/xorg-proto )
	xinerama? ( x11-base/xorg-proto )
	xscreensaver? ( x11-base/xorg-proto )
"
ASM_DEP="dev-lang/yasm"
BDEPEND="
	virtual/pkgconfig
	amd64? ( ${ASM_DEP} )
	doc? (
		app-text/docbook-xml-dtd
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
	x86? ( ${ASM_DEP} )
"
RDEPEND+="selinux? ( sec-policy/selinux-mplayer )"

LICENSE="GPL-2"
SLOT="0"
#if [[ ${PV} != *9999* ]]; then
#	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
#fi

# faac codecs are nonfree
# libcdio support: prefer libcdio over cdparanoia and don't check for cddb w/cdio
# dvd navigation requires dvd read support
# ass and freetype font require iconv and ass requires freetype fonts
# unicode transformations are usefull only with iconv
# radio requires oss or alsa backend
REQUIRED_USE="
	dga? ( X )
	dvdnav? ( dvd )
	enca? ( iconv )
	ggi? ( X )
	libass? ( truetype )
	opengl? ( X )
	osdmenu? ( X )
	truetype? ( iconv )
	vdpau? ( X )
	vidix? ( X )
	xinerama? ( X )
	xscreensaver? ( X )
	xv? ( X )"
RESTRICT="faac? ( bindist )"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		elog
		elog "This is a live ebuild which installs the latest from upstream's"
		elog "subversion repository, and is unsupported by Gentoo."
		elog "Everything but bugs in the ebuild itself will be ignored."
		elog
	fi

	if use cpudetection; then
		ewarn
		ewarn "You've enabled the cpudetection flag. This feature is"
		ewarn "included mainly for people who want to use the same"
		ewarn "binary on another system with a different CPU architecture."
		ewarn "MPlayer will already detect your CPU settings by default at"
		ewarn "buildtime; this flag is used for runtime detection."
		ewarn "You won't need this turned on if you are only building"
		ewarn "mplayer for this system. Also, if your compile fails, try"
		ewarn "disabling this use flag."
	fi
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		subversion_src_unpack

		cd "${WORKDIR}" || die
		rm -rf "${WORKDIR}/${P}/ffmpeg/" || die
		( EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/ffmpeg/" git-r3_src_unpack )
	else
		unpack ${A}
	fi

	if [[ ${PV} == *9999* || "${PV%_rc*}" == "${PV}" ]]; then
		cd "${S}" || die
		cp "${FILESDIR}/dump_ffmpeg.sh" . || die
		chmod +x dump_ffmpeg.sh || die
		./dump_ffmpeg.sh
	fi

	if ! use truetype; then
		unpack font-arial-iso-8859-1.tar.bz2 \
			font-arial-iso-8859-2.tar.bz2 \
			font-arial-cp1250.tar.bz2
	fi
}

src_prepare() {
	default

	local svf=snapshot_version
	if [[ ${PV} == *9999* ]]; then
		# Set SVN version manually
		subversion_wc_info
		printf "${ESVN_WC_REVISION}" > ${svf} || die
	fi

	if [[ ! -f VERSION ]]; then
		[[ -f "${svf}" ]] || die "Missing ${svf}. Did you generate your snapshot with prepare_mplayer.sh?"

		local sv=$(<${svf})
		printf "SVN-r${sv} (Gentoo)" > VERSION || die
	fi

	# Fix path to bash executable in configure scripts
	sed -i -e "1c\#!${EPREFIX}/bin/bash" configure version.sh || die

	# Use sane default for >=virtual/udev-197
	sed -i -e '/default_dvd_device/s:/dev/dvd:/dev/cdrom:' configure || die
}

src_configure() {
	local myconf=()
	local uses i

	# Set LINGUAS
	[[ -n ${LINGUAS} ]] && LINGUAS="${LINGUAS/da/dk}"
	[[ -n ${LINGUAS} ]] && LINGUAS="${LINGUAS/zh/zh_CN}" #482968

	# mplayer ebuild uses "use foo || --disable-foo" to forcibly disable
	# compilation in almost every situation. The reason for this is
	# because if --enable is used, it will force the build of that option,
	# regardless of whether the dependency is available or not.

	#####################
	# Optional features #
	#####################
	# Disable svga since we don't want it
	# Disable arts since we don't have kde3
	# Always disable internal ass
	# Disable opus and ilbc since it only controls support in internal
	# ffmpeg which we do not use
	myconf+=(
		--disable-arts
		--disable-ass-internal
		--disable-directfb
		--disable-kai
		--disable-libilbc
		--disable-libnut
		--disable-libopus
		--disable-svga --disable-svgalib_helper
		--disable-xvmc
		$(use_enable network networking)
		$(use_enable joystick)
	)

	uses="bl bluray enca ftp rtc vcd" # nemesi <- not working with in-tree ebuild
	myconf+=( --disable-nemesi ) # nemesi automagic disable
	for i in ${uses}; do
		use ${i} || myconf+=( --disable-${i} )
	done
	use bidi  || myconf+=( --disable-fribidi )
	use ipv6  || myconf+=( --disable-inet6 )
	use libass || myconf+=( --disable-ass )
	use rar   || myconf+=( --disable-unrarexec )
	use samba || myconf+=( --disable-smb )
	use lirc  || myconf+=( --disable-lirc --disable-lircc --disable-apple-ir )

	# libcdio support: prefer libcdio over cdparanoia
	# don't check for cddb w/cdio
	if use cdio; then
		myconf+=( --disable-cdparanoia )
	else
		myconf+=( --disable-libcdio )
		use cdparanoia || myconf+=( --disable-cdparanoia )
		use cddb || myconf+=( --disable-cddb )
	fi

	################################
	# DVD read, navigation support #
	################################
	#
	# dvdread - accessing a DVD
	# dvdnav - navigation of menus
	use dvd || myconf+=( --disable-dvdread )
	use dvdnav || myconf+=( --disable-dvdnav )

	#############
	# Subtitles #
	#############
	#
	# SRT/ASS/SSA (subtitles) requires freetype support
	# freetype support requires iconv
	# iconv optionally can use unicode
	use truetype || myconf+=( --disable-freetype )
	use iconv || myconf+=( --disable-iconv --charset=noconv )
	use iconv && use unicode && myconf+=( --charset=UTF-8 )

	#####################################
	# DVB / Video4Linux / Radio support #
	#####################################
	myconf+=( --disable-tv-bsdbt848 )
	# gone since linux-headers-2.6.38
	myconf+=( --disable-tv-v4l1 )
	if { use dvb || use v4l || use pvr || use radio; }; then
		use dvb || myconf+=( --disable-dvb )
		use pvr || myconf+=( --disable-pvr )
		use v4l || myconf+=( --disable-tv-v4l2 )
		if use radio && { use dvb || use v4l; }; then
			myconf+=(
				--enable-radio
				$(use_enable encode radio-capture)
			)
		else
			myconf+=(
				--disable-radio-v4l2
				--disable-radio-bsdbt848
			)
		fi
	else
		myconf+=(
			--disable-tv
			--disable-tv-v4l2
			--disable-radio
			--disable-radio-v4l2
			--disable-radio-bsdbt848
			--disable-dvb
			--disable-v4l2
			--disable-pvr
		)
	fi

	##########
	# Codecs #
	##########
	myconf+=( --disable-musepack ) # Use internal musepack codecs for SV7 and SV8 support
	myconf+=( --disable-libmpeg2-internal ) # always use system media-libs/libmpeg2
	myconf+=( --disable-gif ) # relies on to-be-removed giflib internals https://sourceforge.net/p/giflib/bugs/132/
	use dts || myconf+=( --disable-libdca )
	if ! use mp3; then
		myconf+=(
			--disable-mp3lame
			--disable-mpg123
		)
	fi
	uses="a52 bs2b dv gsm lzo rtmp vorbis"
	for i in ${uses}; do
		use ${i} || myconf+=( --disable-lib${i} )
	done

	uses="faad jpeg libmpeg2 live mad mng png pnm speex tga theora tremor"
	for i in ${uses}; do
		use ${i} || myconf+=( --disable-${i} )
	done
	# Pulls an outdated libopenjpeg, ffmpeg provides better support for it
	myconf+=( --disable-libopenjpeg )

	# Encoding
	uses="faac x264 xvid toolame twolame"
	if use encode; then
		for i in ${uses}; do
			use ${i} || myconf+=( --disable-${i} )
		done
	else
		myconf+=( --disable-mencoder )
		for i in ${uses}; do
			myconf+=( --disable-${i} )
			use ${i} && elog "Useflag \"${i}\" will only be useful for encoding, i.e., with \"encode\" useflag enabled."
		done
	fi

	#################
	# Binary codecs #
	#################
	myconf+=( --disable-qtx --disable-real --disable-win32dll )

	################
	# Video Output #
	################
	uses="md5sum sdl yuv4mpeg"
	for i in ${uses}; do
		use ${i} || myconf+=( --disable-${i} )
	done
	use aalib || myconf+=( --disable-aa )
	use fbcon || myconf+=( --disable-fbdev )
	use libcaca || myconf+=( --disable-caca )
	use zoran || myconf+=( --disable-zr )

	if ! use kernel_linux || ! use video_cards_mga; then
		 myconf+=( --disable-mga --disable-xmga )
	fi

	myconf+=(
		--disable-3dfx
		--disable-tdfxvid
		--disable-tdfxfb
	)

	# sun card, disable by default, see bug #258729
	myconf+=( --disable-xvr100 )

	################
	# Audio Output #
	################
	myconf+=( --disable-esd )
	uses="alsa jack ladspa nas openal"
	for i in ${uses}; do
		use ${i} || myconf+=( --disable-${i} )
	done
	use pulseaudio || myconf+=( --disable-pulse )
	if ! use radio; then
		use oss || myconf+=( --disable-ossaudio )
	fi

	####################
	# Advanced Options #
	####################
	# Platform specific flags, hardcoded on amd64 (see below)
	use cpudetection && myconf+=( --enable-runtime-cpudetection )

	uses="3dnow 3dnowext avx avx2 fma3 fma4 mmx mmxext sse sse2 sse3 ssse3 xop"
	for i in ${uses}; do
		myconf+=( $(use_enable cpu_flags_x86_${i} ${i}) )
	done
	myconf+=( $(use_enable cpu_flags_x86_sse4_1 sse4) )
	myconf+=( $(use_enable cpu_flags_x86_sse4_2 sse42) )

	myconf+=(
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable shm)
	)

	use debug && myconf+=( --enable-debug=3 )

	if use x86 && gcc-specs-pie; then
		filter-flags -fPIC -fPIE
		append-ldflags -nopie
	fi

	###########################
	# X enabled configuration #
	###########################
	myconf+=( --disable-gui )
	myconf+=( --disable-vesa )
	uses="ggi vdpau xinerama xv"
	for i in ${uses}; do
		use ${i} || myconf+=( --disable-${i} )
	done
	use dga          || myconf+=( --disable-dga1 --disable-dga2 )
	use opengl       || myconf+=( --disable-gl )
	use osdmenu      && myconf+=( --enable-menu )
	use vidix        || myconf+=( --disable-vidix --disable-vidix-pcidb )
	use xscreensaver || myconf+=( --disable-xss )
	use X            || myconf+=( --disable-x11 )

	############################
	# OSX (aqua) configuration #
	############################
	if use aqua; then
		myconf+=(
			--enable-macosx-finder
			--enable-macosx-bundle
		)
	fi

	# Note: --enable-gnutls only makes sense with --enable-ffmpeg_a
	edo ./configure \
		--cc="$(tc-getCC)" \
		--host-cc="$(tc-getBUILD_CC)" \
		--prefix="${EPREFIX}/usr" \
		--bindir="${EPREFIX}/usr/bin" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--confdir="${EPREFIX}/etc/mplayer" \
		--datadir="${EPREFIX}/usr/share/mplayer${namesuf}" \
		--mandir="${EPREFIX}/usr/share/man" \
		--disable-ffmpeg_a \
		--disable-gnutls \
		"${myconf[@]}"
}

src_compile() {
	default

	# Build only user-requested docs if they're available.
	if use doc ; then
		# Select available languages from ${LINGUAS}
		local ALLOWED_LINGUAS="cs de en es fr hu it pl ru zh_CN"
		local BUILT_DOCS=()
		local i

		for i in ${LINGUAS} ; do
			has ${i} ${ALLOWED_LINGUAS} && BUILT_DOCS+=( ${i} )
		done

		if [[ -z ${BUILT_DOCS[@]} ]]; then
			emake -j1 html-chunked
		else
			for i in ${BUILT_DOCS[@]}; do
				emake -j1 html-chunked-${i}
			done
		fi
	fi
}

src_install() {
	local i

	emake \
		DESTDIR="${D}" \
		INSTALLSTRIP="" \
		install

	dodoc AUTHORS Changelog Copyright README etc/codecs.conf

	docinto tech/
	dodoc DOCS/tech/{*.txt,MAINTAINERS,mpsub.sub,playtree,TODO,wishlist}
	docinto TOOLS/
	dodoc -r TOOLS/*
	docinto tech/mirrors/
	dodoc DOCS/tech/mirrors/*

	if use doc; then
		docinto html/
		dodoc -r "${S}"/DOCS/HTML/*
	fi

	if ! use truetype; then
		dodir /usr/share/mplayer/fonts

		# Do this generic, as the mplayer people like to change the structure
		# of their zips ...
		local i
		for i in $(find "${WORKDIR}/" -type d -name 'font-arial-*'); do
			cp -pPR "${i}" "${ED}/usr/share/mplayer/fonts"
		done

		# Fix the font symlink ...
		rm -rf "${ED}/usr/share/mplayer/font"
		dosym fonts/font-arial-14-iso-8859-1 /usr/share/mplayer/font
	fi

	insinto /etc/mplayer
	newins "${S}/etc/example.conf" mplayer.conf
	cat >> "${ED}/etc/mplayer/mplayer.conf" <<- _EOF_
	# Config options can be section specific, global
	# options should go in the default section
	[default]
	_EOF_

	doins "${S}/etc/input.conf"
	if use osdmenu; then
		doins "${S}/etc/menu.conf"
	fi

	if use truetype; then
		cat >> "${ED}/etc/mplayer/mplayer.conf" <<- _EOF_
		fontconfig=1
		subfont-osd-scale=4
		subfont-text-scale=3
		_EOF_
	fi

	# bug 256203
	if use rar; then
		cat >> "${ED}/etc/mplayer/mplayer.conf" <<- _EOF_
		unrarexec=${EPREFIX}/usr/bin/unrar
		_EOF_
	fi

	dosym -r /etc/mplayer/mplayer.conf /usr/share/mplayer/mplayer.conf
	newbin "${S}/TOOLS/midentify.sh" midentify
}

pkg_preinst() {
	[[ -d ${EROOT}/usr/share/mplayer/Skin/default ]] && \
		rm -rf "${EROOT}/usr/share/mplayer/Skin/default"
}

pkg_postrm() {
	# Cleanup stale symlinks
	[[ -L "${EROOT}/usr/share/mplayer/font" &&
			! -e "${EROOT}/usr/share/mplayer/font" ]] && \
		rm -f "${EROOT}/usr/share/mplayer/font"

	[[ -L "${EROOT}/usr/share/mplayer/subfont.ttf" &&
			! -e "${EROOT}/usr/share/mplayer/subfont.ttf" ]] && \
		rm -f "${EROOT}/usr/share/mplayer/subfont.ttf"
}
