# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="Quake/Tenebrae based, single player game"
HOMEPAGE="http://industri.sourceforge.net/"
SRC_URI="mirror://sourceforge/industri/industri_BIN-${PV}-src.tar.gz
	mirror://sourceforge/industri/industri-1.00.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="cdinstall"

RDEPEND="virtual/opengl
	x11-libs/libXxf86dga
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXxf86vm
	media-libs/libpng:0
	cdinstall? ( games-fps/quake1-data )"
DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto
	x11-proto/xextproto
	x11-proto/xf86vidmodeproto
	x11-proto/xproto
	app-arch/unzip"

S=${WORKDIR}/industri_BIN

src_prepare() {
	mv linux/Makefile{.i386linux,}
	sed -i -e "s:-mpentiumpro.*:${CFLAGS} \\\\:" linux/Makefile || die

	# Remove duplicated typedefs #71841
	for typ in PFNGLFLUSHVERTEXARRAYRANGEAPPLEPROC PFNGLVERTEXARRAYRANGEAPPLEPROC ; do
		if echo '#include <GL/gl.h>' | $(tc-getCC) -E - 2>/dev/null | grep -sq ${typ} ; then
			sed -i \
				-e "/^typedef.*${typ}/d" \
				glquake.h || die
		fi
	done

	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:g' \
		gl_warp.c || die

	epatch "${FILESDIR}"/${P}-exec-stack.patch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-glext.patch
}

src_compile() {
	emake \
		-C linux \
		MASTER_DIR="${GAMES_DATADIR}"/quake1 \
		build_release
}

src_install() {
	newgamesbin linux/release*/bin/industri.run industri
	dogamesbin "${FILESDIR}"/industri.pretty
	insinto /usr/share/icons
	doins industri.ico quake.ico
	dodoc linux/README
	cd "${WORKDIR}"/${PN}
	dodoc *.txt
	insinto "${GAMES_DATADIR}"/quake1/${PN}
	doins *.pak *.cfg
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! use cdinstall ; then
		elog "You need to copy pak0.pak to ${GAMES_DATADIR}/quake1 to play."
	fi
}
