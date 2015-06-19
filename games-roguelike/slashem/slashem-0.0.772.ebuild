# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/slashem/slashem-0.0.772.ebuild,v 1.9 2014/08/10 21:20:58 slyfox Exp $

inherit eutils flag-o-matic games

SE_VER="0.0.7E7"
SE_FIXVER="${SE_VER}F2"
SE_PN="se007e7f2.tar.gz"
SE_CONF="conf12s.tar.gz"

DESCRIPTION="Super Lotsa Added Stuff Hack - Extended Magic. A Nethack Variant"
HOMEPAGE="http://www.slashem.org/"
#SRC_URI="http://www.juiblex.co.uk/nethack/slashem/${SE_PN}"
SRC_URI="mirror://sourceforge/slashem/${SE_PN}
	http://www.juiblex.co.uk/nethack/config/${SE_CONF}"

LICENSE="nethack"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X sdl opengl"

XDEPEND="x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXau
	x11-libs/libXdmcp"

#	qt? ( =dev-qt/qt2* ) this version has overflow bugs #79720
RDEPEND=">=sys-libs/ncurses-5.2-r5
	X? ( ${XDEPEND} )
	opengl? ( virtual/opengl
		media-libs/libsdl )
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}
	dev-util/yacc"

HACKDIR=${GAMES_STATEDIR}/${PN}
S=${WORKDIR}/slashem-${SE_FIXVER}

src_unpack() {
	unpack ${SE_PN}
	cd "${S}"
	EPATCH_SUFFIX="patch"
	epatch "${FILESDIR}"/${SE_VER}

	# This copies the /sys/unix Makefile.*s to their correct places for
	# seding and compiling.
	append-flags -I../include -I/usr/X11R6/include

	cd "${S}"/sys/unix
	source setup.sh || die

	unpack ${SE_CONF}
	cp -f "${FILESDIR}"/${SE_VER}/*.configure . || die
	for c in RedHat9 FHS20 Gentoo prepare-gui Proxy ; do
		./config ${c} ../..
	done

	if use X ; then
		./config X11 ../.. || die "X config"
	fi
	# SDL require X11
	for v in sdl ; do #qt
		use ${v} && { ./config ${v} ../.. || die "${v} config"; }
		./config X11 ../.. || die "X config"
	done
	# OpenGL requires SDL
	if use opengl ; then
		./config opengl ../.. || die "opengl config"
		./config sdl ../.. || die "sdl config"
		./config X11 ../.. || die "X config"
	fi

	cd "${S}"
	sed -i \
		-e "s:^\(\#  define HACKDIR \).*:\1 \"${HACKDIR}\":" \
		include/config.h || die "config.h sed"
	sed -i \
		-e "s:^\(CFLAGS =\).*:\1 ${CFLAGS}:" \
		src/Makefile || die "src/makefile sed"
	sed -i \
		-e "s:^\(FILE_AREA_UNSHARE =\).*:\1 $(games_get_libdir)/${PN}:" \
		Makefile || die "makefile sed"
	sed -i \
		-e "s:^\(\#define FILE_AREA_UNSHARE	\).*:\1\"$(games_get_libdir)/${PN}/\":" \
		include/unixconf.h || die "unixconf.h sed"
}

src_compile() {
	emake all || die "emake all"
	cd "${S}"/util
	emake recover || die "emake recover"
}

src_install() {
	emake \
		GAMEPERM=0750 \
		SHELLDIR="${D}/${GAMES_BINDIR}" \
		FILE_AREA_VAR="${D}/${HACKDIR}" \
		FILE_AREA_SAVE="${D}/${HACKDIR}"/save \
		FILE_AREA_SHARE="${D}/${GAMES_DATADIR}"/${PN} \
		FILE_AREA_UNSHARE="${D}/$(games_get_libdir)"/${PN} \
		FILE_AREA_DOC="${D}"/usr/share/doc/${PF} \
		install || die "emake install failed"
	dodoc doc/*.txt
	dodoc dat/license
	doman doc/slashem.6

	# The final /usr/bin/slashem is a sh script.  This fixes the hard-coded
	# HACKDIR directory so it doesn't point to ${D}/usr/share/slashemdir
	dosed "s:^\(HACKDIR=\).*:\1${HACKDIR}:" "${GAMES_BINDIR}"/${PN}
	dosed "s:^\(HACK=\).*:\1$(games_get_libdir)/${PN}/${PN}:" "${GAMES_BINDIR}"/${PN}

	newgamesbin util/recover recover-slashem || die "recover install"

	if use X ; then
		# install slashem fonts
		dodir "${GAMES_DATADIR}"/${PN}/fonts
		cd "${S}"/win/X11
		bdftopcf -o nh10.pcf nh10.bdf || die "Converting fonts failed"
		bdftopcf -o ibm.pcf ibm.bdf || die "Converting fonts failed"
		insinto "${GAMES_DATADIR}"/${PN}/fonts
		doins *.pcf
		cd "${D}${GAMES_DATADIR}"/${PN}/fonts
		mkfontdir || die "The action mkfontdir ${GAMES_DATADIR}/${PN}/fonts failed"

		# copy slashem X application defaults
		cd "${S}"/win/X11
		sed -i \
			-e 's/^\(SlashEM\*font:\).*/\1 				fixed/' \
			-e 's/^\(SlashEM\*map\*font:\).*/\1 			fixed/' \
			-e 's:^!\(SlashEM.tile_file.*\):\1:' \
			SlashEM.ad || die "Patching SlashEM.ad for X failed"

		insinto /etc/X11/app-defaults
		newins SlashEM.ad SlashEM || die "app-defaults failed"
	fi

	insinto "${GAMES_DATADIR}"/${PN}
	doins "${FILESDIR}"/${SE_VER}/dot.slashemrc

	local windowtypes="tty"
	#use qt     && windowtypes="${windowtypes} qt"
	use X      && windowtypes="${windowtypes} x11"
	use sdl    && windowtypes="${windowtypes} sdl"
	use opengl && windowtypes="${windowtypes} gl"
	set -- ${windowtypes}
	dosed "s:GENTOO_WINDOWTYPES:${windowtypes}:" "${GAMES_DATADIR}"/${PN}/dot.slashemrc
	insinto /etc/skel
	newins "${D}/${GAMES_DATADIR}"/${PN}/dot.slashemrc .slashemrc
	insinto /etc/slashem
	doins "${FILESDIR}"/${SE_VER}/proxy.slashemrc

	keepdir "${HACKDIR}"/save
	prepgamesdirs
	fperms -R g+w "${HACKDIR}"
}

pkg_postinst() {
	games_pkg_postinst
	elog "You may want to look at /etc/skel/.slashemrc for interesting options"
}
