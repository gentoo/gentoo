# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
fromcvs=0
inherit unpacker eutils flag-o-matic games

DEMO="3dduke13.zip"

DESCRIPTION="Port of the original Duke Nukem 3D"
HOMEPAGE="http://icculus.org/projects/duke3d/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	demo? (
		ftp://ftp.3drealms.com/share/${DEMO}
		ftp://ftp.planetmirror.com/pub/gameworld/downloads/${DEMO}
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="hppa ppc x86"
IUSE="demo pic perl opengl"

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-sound/timidity++
	media-sound/timidity-eawpatches
	perl? ( dev-lang/perl[-ithreads] )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	demo? ( app-arch/unzip )
	!pic? ( x86? ( dev-lang/nasm ) )"

S=${WORKDIR}/${PN}

use_tf() { use ${1} && echo "true" || echo "false"; }

src_unpack() {
	unpack ${A}
	if use demo ; then
		unpack_zip DN3DSW13.SHR
	fi
}

src_prepare() {
	# configure buildengine
	cd "${S}/source/buildengine"
	sed -i \
		-e "/^useperl := / s:=.*:= $(use_tf perl):" \
		-e "/^useopengl := / s:=.*:= $(use_tf opengl):" \
		-e "/^usephysfs := / s:=.*:= false:" \
		-e 's:-O3::' -e 's: -g : :' \
		-e 's:/usr/lib/perl5/i386-linux/CORE/libperl.a::' \
		Makefile || die
	epatch "${FILESDIR}/${PV}-endian.patch"

	# configure duke3d
	cd "${S}/source"
	# need to sync features with build engine
	epatch \
		"${FILESDIR}/${PV}-credits.patch" \
		"${FILESDIR}/${PV}-duke3d-makefile-opts.patch" \
		"${FILESDIR}/${PV}-gcc34.patch" \
		"${FILESDIR}"/${P}-gcc4.patch \
		"${FILESDIR}"/${P}-noinline.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e "/^use_opengl := / s:=.*:= $(use_tf opengl):" \
		-e "/^use_physfs := / s:=.*:= false:" \
		Makefile || die
	if ! use pic && use x86 ; then
		sed -i \
			-e 's:^#USE_ASM:USE_ASM:' buildengine/Makefile || die
		sed -i \
			-e '/^#use_asm := /s:#::' Makefile || die
	fi

	# causes crazy redefine errors with gcc-3.[2-4].x
	replace-flags -O3 -O2
	strip-flags #203969
}

src_compile() {
	emake -C source/buildengine OPTFLAGS="${CFLAGS}"
	emake -C source OPTIMIZE="${CFLAGS}"
}

src_install() {
	games_make_wrapper duke3d "${GAMES_BINDIR}/duke3d.bin" "${GAMES_DATADIR}/${PN}"
	newgamesbin source/duke3d duke3d.bin

	dodoc readme.txt

	cd testdata
	insinto "${GAMES_DATADIR}/${PN}"
	newins defs.con DEFS.CON
	newins game.con GAME.CON
	newins user.con USER.CON
	newins "${FILESDIR}/network.cfg" network.cfg.template
	if use demo ; then
		doins "${WORKDIR}/DUKE3D.GRP"
	fi

	insinto "${GAMES_SYSCONFDIR}"
	doins "${FILESDIR}/duke3d.cfg"
	dosym "${GAMES_SYSCONFDIR}/duke3d.cfg" "${GAMES_DATADIR}/${PN}/DUKE3D.CFG"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	use demo || elog "Put the data files in ${GAMES_DATADIR}/${PN} before playing"
}
