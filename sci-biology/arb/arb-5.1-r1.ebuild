# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Tools for DNA/RNA sequence database handling and data analysis, phylogenetic analysis"
HOMEPAGE="http://www.arb-home.de/"
SRC_URI="
	http://download.arb-home.de/release/arb_${PV}/arbsrc.tgz -> ${P}.tgz
	mirror://gentoo/${P}-glibc2.10.patch.bz2
	https://dev.gentoo.org/~jlec/${P}-linker.patch.bz2"

LICENSE="arb"
SLOT="0"
IUSE="+opengl"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-text/sablotron
	media-libs/libpng
	media-libs/tiff
	www-client/lynx
	x11-libs/libXaw
	x11-libs/libXpm
	x11-libs/motif:0
	opengl? (
		media-libs/glew
		media-libs/freeglut
		|| (
			media-libs/mesa[motif]
			( media-libs/mesa x11-libs/libGLw ) ) )"
RDEPEND="${DEPEND}
	sci-visualization/gnuplot"
# Recommended: libmotif3 gv xfig xterm treetool java

src_unpack() {
	unpack ${A}
	mv arbsrc* ${P}
}

src_prepare() {
	epatch \
		"${WORKDIR}"/${P}-glibc2.10.patch\
		"${WORKDIR}"/${P}-linker.patch \
		"${FILESDIR}"/${PV}-libs.patch \
		"${FILESDIR}"/${PV}-bfr-overflow.patch
	sed -i \
		-e 's/all: checks/all:/' \
		-e "s/GCC:=.*/GCC=$(tc-getCC) ${CFLAGS}/" \
		-e "s/GPP:=.*/GPP=$(tc-getCXX) ${CXXFLAGS}/" \
		-e 's/--export-dynamic/-Wl,--export-dynamic/g' \
		"${S}/Makefile" || die
	cp config.makefile.template config.makefile
	sed -i -e '/^[ \t]*read/ d' -e 's/SHELL_ANS=0/SHELL_ANS=1/' "${S}/arb_install.sh" || die
	use amd64 && sed -i -e 's/ARB_64 := 0/ARB_64 := 1/' config.makefile
	use opengl || sed -i -e 's/OPENGL := 1/OPENGL := 0/' config.makefile
	emake ARBHOME="${S}" links || die
}

src_compile() {
	emake ARBHOME="${S}" PATH="${PATH}:${S}/bin" LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${S}/lib" tarfile || die
	use amd64 && mv arb.tgz arb.64.gentoo.tgz
	use x86 && mv arb.tgz arb.32.gentoo.tgz
	ln -s arb.*.tgz arb.tgz || die
}

src_install() {
	ARBHOME="${D}/opt/arb" "${S}/arb_install.sh" || die
	cat <<- EOF > "${S}/99${PN}"
	ARBHOME=/opt/arb
	PATH=/opt/arb/bin
	LD_LIBRARY_PATH=/opt/arb/lib
	EOF
	doenvd "${S}/99${PN}" || die
}
