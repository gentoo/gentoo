# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#ECVS_SERVER="cvs.tenebrae.sourceforge.net:/cvsroot/tenebrae"
#ECVS_MODULE="tenebrae_0"

inherit toolchain-funcs

DESCRIPTION="Adds stencil shadows and per pixel lights to quake"
HOMEPAGE="http://tenebrae.sourceforge.net/"
SRC_URI="mirror://sourceforge/tenebrae/tenebraedata.zip
	mirror://gentoo/${P}.tbz2"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="
	media-libs/libpng:0
	virtual/glu
	virtual/opengl
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PV}-glhax.patch
	"${FILESDIR}"/${P}-exec-stack.patch
	"${FILESDIR}"/${P}-redef.patch
)

src_prepare() {
	cd tenebrae_0 || die "cd failed"

	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:g' \
		gl_warp.c || die

	default

	cd linux || die "cd failed"
	sed \
		-e "/^LDFLAGS/s:=:+=:" \
		-e "s:-mpentiumpro -O6:${CFLAGS}:" \
		-e "s:CC.*= /usr/bin/gcc:CC?=/usr/bin/gcc:" \
		Makefile.i386linux > Makefile || die
}

src_compile() {
	tc-export CC

	cd "${S}"/tenebrae_0/linux || die "cd failed"
	emake MASTER_DIR="/usr/share/quake1" build_release
}

src_install() {
	newbin tenebrae_0/linux/release*/bin/tenebrae.run tenebrae

	insinto /usr/share/quake1/tenebrae
	doins "${WORKDIR}"/tenebrae/*
	dodoc tenebrae_0/linux/README "${WORKDIR}"/Tenebrae_Readme.txt
}
