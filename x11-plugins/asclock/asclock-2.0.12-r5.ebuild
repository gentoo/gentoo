# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Clock applet for AfterStep"
HOMEPAGE="http://wiki.afterstep.org/index.php?title=AfterStep_Applets_DataBase#asclock"
SRC_URI="mirror://debian/pool/main/a/asclock/${PN}_${PV}.orig.tar.gz"
S="${WORKDIR}/asclock-xlib"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ~sparc x86 ~x64-solaris"

DEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-gcc41.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-fix-implicit-func-decl.patch
	"${FILESDIR}"/${P}-fix_gcc15.patch
)

src_prepare() {
	default

	ln -s themes/classic default_theme || die
}

src_configure() {
	:;
}

src_compile() {
	local x
	for x in asclock parser symbols config; do
		edo $(tc-getCC) \
			${CPPFLAGS} ${CFLAGS} ${ASFLAGS} \
			-c -o ${x}.o ${x}.c
	done

	edo $(tc-getCC) \
		${LDFLAGS} \
		-o asclock \
		asclock.o parser.o symbols.o config.o \
		$($(tc-getPKG_CONFIG) --print-errors --libs x11 xext xpm)
}

src_install() {
	dobin asclock
	local themesdir="/usr/share/${PN}/themes"
	insinto ${themesdir}
	doins -r themes/*
	dodoc README README.THEMES TODO
	cd "${ED}"/${themesdir} || die
	rm Freeamp/Makefile{,.*} || die
	ln -s classic default_theme || die
}
