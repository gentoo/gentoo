# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
#ECVS_SERVER="cvs.tenebrae.sourceforge.net:/cvsroot/tenebrae"
#ECVS_MODULE="tenebrae_0"
#inherit cvs
inherit eutils games

DESCRIPTION="adds stencil shadows and per pixel lights to quake"
HOMEPAGE="http://tenebrae.sourceforge.net/"
SRC_URI="mirror://sourceforge/tenebrae/tenebraedata.zip
	mirror://gentoo/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libpng
	x11-libs/libXxf86vm
	x11-libs/libXxf86dga"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	if [[ -z ${ECVS_MODULE} ]] ; then
		unpack ${A}
	else
		cvs_src_unpack
	fi
}

src_prepare() {
	cd tenebrae_0

	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:g' \
		gl_warp.c || die

	epatch \
		"${FILESDIR}"/${PV}-glhax.patch \
		"${FILESDIR}"/${P}-exec-stack.patch
	cd linux
	sed \
		-e "/^LDFLAGS/s:=:+=:" \
		-e "s:-mpentiumpro -O6:${CFLAGS}:" \
		Makefile.i386linux > Makefile \
		|| die "sed failed"
}

src_compile() {
	cd "${S}"/tenebrae_0/linux
	emake MASTER_DIR="${GAMES_DATADIR}/quake1" build_release || die
}

src_install() {
	newgamesbin tenebrae_0/linux/release*/bin/tenebrae.run tenebrae || die
	insinto "${GAMES_DATADIR}/quake1/tenebrae"
	doins "${WORKDIR}"/tenebrae/* || die "doins data"
	dodoc tenebrae_0/linux/README "${WORKDIR}"/Tenebrae_Readme.txt
	prepgamesdirs
}
