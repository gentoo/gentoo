# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

#ECVS_SERVER="cvs.tenebrae.sourceforge.net:/cvsroot/tenebrae"
#ECVS_MODULE="tenebrae_0"
#inherit cvs
inherit eutils

DESCRIPTION="adds stencil shadows and per pixel lights to quake"
HOMEPAGE="http://tenebrae.sourceforge.net/"
SRC_URI="mirror://sourceforge/tenebrae/tenebraedata.zip
	mirror://gentoo/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	virtual/glu
	virtual/opengl
	media-libs/libpng:0
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-base/xorg-proto"

S=${WORKDIR}

src_unpack() {
	if [[ -z ${ECVS_MODULE} ]] ; then
		unpack ${A}
	else
		cvs_src_unpack
	fi
}

src_prepare() {
	cd tenebrae_0 || die "cd failed"

	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:g' \
		gl_warp.c || die

	eapply "${FILESDIR}"/${PV}-glhax.patch
	eapply "${FILESDIR}"/${P}-exec-stack.patch
	eapply "${FILESDIR}"/${P}-redef.patch

	default

	cd linux || die "cd failed"
	sed \
		-e "/^LDFLAGS/s:=:+=:" \
		-e "s:-mpentiumpro -O6:${CFLAGS}:" \
		Makefile.i386linux > Makefile || die
}

src_compile() {
	cd "${S}"/tenebrae_0/linux || die "cd failed"
	emake MASTER_DIR="/usr/share/quake1" build_release
}

src_install() {
	newbin tenebrae_0/linux/release*/bin/tenebrae.run tenebrae
	insinto "/usr/share/quake1/tenebrae"
	doins "${WORKDIR}"/tenebrae/*
	dodoc tenebrae_0/linux/README "${WORKDIR}"/Tenebrae_Readme.txt
}
