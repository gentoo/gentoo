# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/eternal-lands/eternal-lands-1.9.3-r2.ebuild,v 1.8 2015/03/31 17:53:41 ulm Exp $

EAPI=5
inherit eutils flag-o-matic gnome2-utils games

DESCRIPTION="An online MMORPG written in C and SDL"
HOMEPAGE="http://www.eternal-lands.com"
SRC_URI="mirror://gentoo/elc_1.9.3-20120213.tar.bz2
	http://dev.gentoo.org/~rich0/distfiles/${PN}.png"

LICENSE="eternal_lands"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="debug doc kernel_linux"

RDEPEND="dev-libs/libxml2:=
	media-libs/cal3d:=[-16bit-indices]
	media-libs/freealut
	media-libs/libpng:0=
	media-libs/libsdl:=[X,opengl,video]
	media-libs/libvorbis:=
	media-libs/openal:=
	media-libs/sdl-image:=
	media-libs/sdl-net:=
	>=games-rpg/eternal-lands-data-1.9.3
	sys-libs/zlib:=[minizip]
	virtual/glu
	virtual/opengl
	x11-libs/libX11:=
	x11-libs/libXau:=
	x11-libs/libXdmcp:=
	x11-libs/libXext:="
DEPEND="${RDEPEND}
	>=app-eselect/eselect-opengl-1.0.6-r1
	app-arch/unzip
	virtual/pkgconfig
	doc? ( app-doc/doxygen
		media-gfx/graphviz )
	media-libs/glew"

S="${WORKDIR}/elc"

src_prepare() {
	local BROWSER="firefox"

	sed -i \
		-e 's/#browser/browser/g' \
		-e "s/browser = mozilla/#browser = ${BROWSER}/g" \
		-e "s@#data_dir = /usr/local/games/el/@#data_dir = ${GAMES_DATADIR}/${PN}/@g" \
		el.ini || die "sed failed"

	# Finally, update the server
	sed -i -e '/#server_address =/ s/.*/#server_address = game.eternal-lands.com/' \
		el.ini || die "sed failed"

	epatch "${FILESDIR}/${PN}-1.9.3-glbuild.patch"
	epatch "${FILESDIR}/${PN}-1.9.3-build.patch"
	epatch "${FILESDIR}/${PN}-1.9.3-minizip.patch"

	# remove bundled minizip
	rm io/{crypt,ioapi,unzip,zip}.h || die
	rm io/{ioapi,unzip,zip}.c || die

	cp Makefile.linux Makefile
}

src_compile() {
	emake \
		DEBUG="$(usex debug)" \
		BSD_KERNEL="$(usex !kernel_linux)" \
		DATADIR="${GAMES_DATADIR}/${PN}/"

	if use doc; then
		emake docs
		mv ./docs/html/ ../client || die "Failed to move documentation directory"
	fi
}

src_install() {
	dogamesbin el
	make_desktop_entry el "Eternal Lands"

	insopts -m 0660
	insinto "${GAMES_DATADIR}/${PN}"

	doins -r *.ini *.txt commands.lst

	if use doc ; then
		dohtml -r "${WORKDIR}"/client/*
	fi

	doicon -s 64 "${DISTDIR}/${PN}.png"

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
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

pkg_postrm() {
	gnome2_icon_cache_update
}
