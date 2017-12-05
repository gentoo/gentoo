# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

MY_P=${PN}_5.5-20060227

DESCRIPTION="utilities for configuring and debugging the Linux floppy driver"
HOMEPAGE="http://fdutils.linux.lu/"
SRC_URI="mirror://debian/pool/main/f/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/f/${PN}/${MY_P}-6.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="doc"

RDEPEND=">=sys-fs/mtools-4"
DEPEND="${RDEPEND}
	sys-apps/texinfo
	virtual/os-headers
	doc? ( virtual/texi2dvi )"

S=${WORKDIR}/${PN}-5.5-20060227

src_prepare() {
	local d="${WORKDIR}"/debian/patches
	EPATCH_SOURCE="${d}" epatch $(<"${d}"/series)
	sed -i -e 's:{LDFLAFS}:(LDFLAGS):' src/Makefile.in || die #337721
	# The build sets up config.h and uses some symbols, but forgots to
	# actually include it in most places.
	sed -i '1i#include "../config.h"' src/*.c || die #580060
}

src_configure() {
	econf --enable-fdmount-floppy-only
}

src_compile() {
	emake -j1 $(use doc || echo compile)
}

src_install() {
	dodir /etc
	use doc && dodir /usr/share/info

	emake -j1 DESTDIR="${D}" install

	# The copy in sys-apps/man-pages is more recent
	rm -f "${ED}"/usr/share/man/man4/fd.4 || die

	# Rename to match binary
	mv "${ED}"/usr/share/man/man1/{makefloppies,MAKEFLOPPIES}.1 || die
}
