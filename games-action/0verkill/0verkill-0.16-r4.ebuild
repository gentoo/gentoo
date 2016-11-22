# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="a bloody 2D action deathmatch-like game in ASCII-ART"
HOMEPAGE="http://artax.karlin.mff.cuni.cz/~brain/0verkill/"
SRC_URI="http://artax.karlin.mff.cuni.cz/~brain/0verkill/release/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
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
)

src_prepare() {
	default
	sed -i \
		-e "s:data/:/usr/share/${PN}/data/:" cfg.h || die
	sed -i \
		-e "s:@CFLAGS@ -O3 :@CFLAGS@ :" Makefile.in || die
	sed -i \
		-e "/gettimeofday/s/getopt/getopt calloc/" configure.in || die
	eautoreconf
}

src_configure() {
	econf $(use_with X x)
}

src_install() {
	local x
	dobin 0verkill
	for x in avi bot editor server test_server ; do
		newbin ${x} 0verkill-${x}
	done
	if use X ; then
		dobin x0verkill
		for x in avi editor ; do
			newbin ${x} 0verkill-${x}
		done
	fi

	insinto "/usr/share/${PN}"
	doins -r data grx

	rm doc/README.OS2 doc/Readme\ Win32.txt doc/COPYING
	dodoc -r doc/
}
