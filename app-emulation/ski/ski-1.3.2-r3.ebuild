# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="ia64 instruction set simulator"
HOMEPAGE="http://ski.sourceforge.net/ http://www.gelato.unsw.edu.au/IA64wiki/SkiSimulator"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="motif"

RDEPEND="dev-libs/libltdl:0=
	sys-libs/binutils-libs:0=
	sys-libs/ncurses:0=
	virtual/libelf
	motif? ( x11-libs/motif:0= )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	dev-util/gperf"

# games-sports/ski and app-emulation/ski both install 'ski' binary, bug #653110
RDEPEND="${RDEPEND} !!games-sports/ski"

PATCHES=(
	"${FILESDIR}"/${P}-syscall-linux-includes.patch
	"${FILESDIR}"/${P}-remove-hayes.patch
	"${FILESDIR}"/${P}-no-local-ltdl.patch
	"${FILESDIR}"/${P}-AC_C_BIGENDIAN.patch
	"${FILESDIR}"/${P}-configure-withval.patch
	"${FILESDIR}"/${P}-binutils.patch
	"${FILESDIR}"/${P}-uselib.patch #592226
	"${FILESDIR}"/${P}-ncurses-config.patch
	"${FILESDIR}"/${P}-prototypes.patch
	"${FILESDIR}"/${P}-glibc-2.28.patch
)

src_prepare() {
	default

	rm -rf libltdl src/ltdl.[ch] macros/ltdl.m4

	AT_M4DIR="macros" eautoreconf
}

src_configure() {
	econf \
		--without-included-ltdl \
		--without-gtk \
		$(use_with motif x11)
}
