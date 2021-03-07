# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A bloody 2D action deathmatch-like game in ASCII-ART"
HOMEPAGE="http://freshmeat.sourceforge.net/projects/0verkill"
SRC_URI="http://artax.karlin.mff.cuni.cz/~brain/0verkill/release/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="X? ( x11-libs/libXpm )"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-docs.patch
	"${FILESDIR}"/${P}-home-overflow.patch
	"${FILESDIR}"/${P}-segv.patch
	"${FILESDIR}"/${P}-gentoo-paths.patch
	"${FILESDIR}"/${P}-ovflfix.patch
	"${FILESDIR}"/${P}-CC.patch
	"${FILESDIR}"/${P}-underflow-check.patch #136222
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	sed -i \
		-e "s:data/:/usr/share/${PN}/data/:" cfg.h || die
	sed -i \
		-e "s:@CFLAGS@ -O3 :@CFLAGS@ :" Makefile.in || die
	sed -i \
		-e "/gettimeofday/s/getopt/getopt calloc/" configure.in || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_with X x)
}

src_install() {
	dobin 0verkill
	local x
	for x in avi bot editor server test_server ; do
		newbin ${x} 0verkill-${x}
	done
	if use X ; then
		dobin x0verkill
		for x in avi editor ; do
			newbin ${x} 0verkill-${x}
		done
	fi

	insinto /usr/share/${PN}
	doins -r data grx

	rm doc/{README.OS2,"Readme Win32.txt",COPYING} || die
	dodoc -r doc/.
}
