# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils flag-o-matic games

DESCRIPTION="An online MMORPG written in C and SDL"
HOMEPAGE="http://www.eternal-lands.com"
SRC_URI="http://dev.gentoo.org/~rich0/distfiles/elc_1.9.2-20110618.tar.bz2
	http://dev.gentoo.org/~rich0/distfiles/eternal-lands.png"

LICENSE="eternal_lands"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="debug doc kernel_linux"

RDEPEND="x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	virtual/opengl
	virtual/glu
	media-libs/libsdl[X]
	media-libs/sdl-net
	media-libs/sdl-image
	media-libs/openal
	media-libs/freealut
	media-libs/libvorbis
	dev-libs/libxml2
	media-libs/cal3d[-16bit-indices]
	media-libs/libpng
	>=games-rpg/eternal-lands-data-1.9.2"

DEPEND="${RDEPEND}
	>=app-eselect/eselect-opengl-1.0.6-r1
	app-arch/unzip
	doc? ( app-doc/doxygen
		media-gfx/graphviz )"

#ECVS_SERVER="cvs.elc.berlios.de:/cvsroot/elc"
#ECVS_MODULE="elc"
#ECVS_USER="anonymous"
#ECVS_LOCALNAME="elc"
#ECVS_PASS=""
#ECVS_CVS_OPTIONS="-dP -z3"
#ECVS_BRANCH="elc_1_8_0"

#S="${WORKDIR}/${ECVS_MODULE}"
S="${WORKDIR}/elc"

src_unpack() {
#	cvs_src_unpack
	OPTIONS="-DDATA_DIR="\\\\\"${GAMES_DATADIR}/${PN}/\\\\\"""
	S_CLIENT="${WORKDIR}/elc"
	BROWSER="firefox"
	unpack ${A}
	cd "${S}"
}

src_prepare() {
	# Add debugging options
	if use debug ; then
		OPTIONS="${OPTIONS} -DMEMORY_DEBUG"
		append-flags -ggdb
	fi

	# Clean compile flags (make Gentoo friendly)
	sed -i \
		-e "s@CFLAGS=\$(PLATFORM) \$(CWARN) -O0 -ggdb -pipe@CFLAGS = ${CFLAGS} ${OPTIONS} @g" \
		-e "s@CXXFLAGS=\$(PLATFORM) \$(CXXWARN) -O0 -ggdb -pipe@CXXFLAGS = ${CXXFLAGS} ${OPTIONS} @g" \
		-e 's/lopenal/lopenal -l alut/' \
		Makefile.linux || die "sed failed"

	sed -i \
		-e 's/#browser/browser/g' \
		-e "s/browser = mozilla/#browser = ${BROWSER}/g" \
		-e "s@#data_dir = /usr/local/games/el/@#data_dir = ${GAMES_DATADIR}/${PN}/@g" \
		el.ini || die "sed failed"

	# Support BSD in the Linux makefile - it's easier
	use kernel_linux || sed -i \
		-e 's/^CFLAGS=.*/& -DBSD/' \
		Makefile.linux || die "sed failed"

	# Clean up library flag order for --as-needed
#	sed -i -e 's/@$(LINK) $(CFLAGS) $(LDFLAGS) -o $(EXE) $(OBJS)/@$(LINK) $(CFLAGS) -o $(EXE) $(OBJS) $(LDFLAGS)/' Makefile.linux

	# Finally, update the server
	sed -i -e '/#server_address =/ s/.*/#server_address = game.eternal-lands.com/' \
		el.ini || die "sed failed"

	sed -i -e 's:FEATURES:EL_FEATURES:' make.defaults
	sed -i -e 's:FEATURES:EL_FEATURES:' Makefile.linux

	if use debug; then
		sed -i -e 's/#\(EL_FEATURES += MEMORY_DEBUG\)/\1/' make.defaults
		sed -i -e 's/#\(EL_FEATURES += MEMORY_DEBUG\)/\1/' Makefile.linux
	fi

	cp Makefile.linux Makefile

	epatch "${FILESDIR}/${PN}-1.9.2-glext.patch"
#	epatch "${FILESDIR}/${PN}-1.9.1-libpng.patch"

# Fix for Gentoo zlib OF redefine

	sed -i '1i#define OF(x) x' `find -name "*.c"` || die "sed failed"
}

src_compile() {
	emake || die "make failed"

	if use doc; then
		emake docs || die "Failed to create documentation, try with USE=-doc"
		mv ./docs/html/ ../client || die "Failed to move documentation directory"
	fi
}

src_install() {
	doicon "${DISTDIR}/eternal-lands.png" ${PN}.png

	newgamesbin el.x86.linux.bin el \
		|| die "newgamesbin failed"
	make_desktop_entry el "Eternal Lands" \
		|| die "make_desktop_entry failed"
	insopts -m 0660
	insinto "${GAMES_DATADIR}/${PN}"

	doins -r *.ini *.txt commands.lst \
		|| die "doins failed"

	if use doc ; then
		dohtml -r client/*
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Auto Update is now enabled in Eternal Lands"
	elog "If an update occurs then the client will suddenly exit"
	elog "Updates only happen when the game first loads"
	elog "Please don't report this behaviour as a bug"

	# Ensure that the files are writable by the game group for auto
	# updating.
	chmod -R g+rw "${ROOT}/${GAMES_DATADIR}/${PN}"

	# Make sure new files stay in games group
	find "${ROOT}/${GAMES_DATADIR}/${PN}" -type d -exec chmod g+sx {} \;

}
