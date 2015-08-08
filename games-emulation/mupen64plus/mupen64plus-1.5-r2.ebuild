# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils flag-o-matic games toolchain-funcs

MY_P="Mupen64Plus-${PV/./-}-src"

PATCH_VERSION="20100507"

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator"
HOMEPAGE="http://code.google.com/p/mupen64plus/"
SRC_URI="http://mupen64plus.googlecode.com/files/${MY_P}.tar.gz mirror://gentoo/${P}-patches-${PATCH_VERSION}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+gtk libsamplerate lirc qt4 cpu_flags_x86_sse"

# GTK+ is currently required by plugins even if no GUI support is enabled
RDEPEND="virtual/opengl
	media-libs/freetype:2
	media-libs/libpng
	media-libs/libsdl
	media-libs/sdl-ttf
	media-fonts/dejavu
	sys-libs/zlib[minizip]
	x11-libs/gtk+:2
	libsamplerate? ( media-libs/libsamplerate )
	lirc? ( app-misc/lirc )
	qt4? ( dev-qt/qtgui:4
		dev-qt/qtcore:4 )
	app-arch/xz-utils"

DEPEND="${RDEPEND}
	dev-lang/yasm
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if [[ ! $(tc-getCC) =~ gcc ]]; then
		eerror
		eerror "Compilers like clang and icc are not supported at this point"
		eerror
		die "You need gcc to build ${PN}"
	fi

	if ! use gtk && ! use qt4; then
		ewarn "Building ${PN} without any GUI! To get one, enable USE=gtk or USE=qt4."
	elif use gtk && use qt4; then
		ewarn "Only one GUI can be built, using GTK+ one."
	fi

	games_pkg_setup
}

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/patches" EPATCH_SUFFIX="patch" \
		epatch

	rm -rf main/zip
	epatch "${FILESDIR}"/${P}-minizip.patch #383845

	sed -i \
		-e "s:/usr/local/share/mupen64plus:${GAMES_DATADIR}/mupen64plus:" \
		-e "s:%PUT_PLUGIN_PATH_HERE%:$(games_get_libdir)/${PN}/plugins/:" \
		main/main.c || die "sed failed"

	# Fix 010_all_fix-desktop-file.patch instead of using sed on the next major bump
	sed -i \
		-e "s:^Icon=mupen64plus-large.xpm:Icon=mupen64plus:" \
		mupen64plus.desktop.in || die "sed failed"
	epatch "${FILESDIR}"/${P}-gcc46.patch
}

get_opts() {
	if use amd64 || use x86 ; then
		echo -n "CPU=X86 ARCH=64BITS$(use x86 && echo -n _32) "
	fi

	use libsamplerate || echo -n "NO_RESAMP=1 "
	use lirc && echo -n "LIRC=1 "
	use cpu_flags_x86_sse || echo -n "NO_ASM=1 "

	echo -n GUI=
	if use gtk; then
		echo -n GTK2
	elif use qt4; then
		echo -n QT4
	else
		echo -n NONE
	fi
}

src_compile() {
	tc-export CC CXX
	use x86 && use cpu_flags_x86_sse && append-flags -fomit-frame-pointer
	emake $(get_opts) DBGSYM=1 CC="${CC}" CXX="${CXX}" LD="${CC}" all || die "make failed"
}

src_install() {
	# These are:
	# 1) prefix - not used really, printed only
	# 2) SHAREDIR
	# 3) BINDIR
	# 4) 'LIBDIR' - where to put plugins in
	# 5) 'MANDIR' - exact directory to put man file in
	# 6) APPLICATIONSDIR - where to put .desktop in

	./install.sh "${D}" \
		"${D}${GAMES_DATADIR}/${PN}" \
		"${D}${GAMES_BINDIR}" \
		"${D}$(games_get_libdir)/${PN}/plugins" \
		"${D}/usr/share/man/man1" \
		"${D}/usr/share/applications" \
		|| or die "install.sh failed"

	# Copy icon into system-wide location
	newicon icons/mupen64plus-large.png ${PN}.png || die "newicon failed"

	# 'Move' docs into correct dir
	rm -r "${D}${GAMES_DATADIR}/${PN}/doc"
	dodoc README RELEASE TODO doc/*.txt "${FILESDIR}/README.gentoo-patches-${PATCH_VERSION}" || die "dodoc failed"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use lirc; then
		elog "For lirc configuration see:"
		elog "http://code.google.com/p/mupen64plus/wiki/LIRC"
	fi
}
