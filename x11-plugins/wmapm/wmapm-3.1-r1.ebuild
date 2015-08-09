# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="WindowMaker DockApp: Battery/Power status monitor for laptops"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/25/${P}.tar.gz"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/18"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

S=${WORKDIR}/${P}/${PN}

src_unpack()
{
	unpack ${A}
	cd "${S}"

	#Respect LDFLAGS, see bug #334747
	sed -i 's/ -o wmapm/ ${LDFLAGS} -o wmapm/' "Makefile"
}

src_compile() {
	emake COPTS="${CFLAGS}" || die "make failed"
}

src_install() {
	dobin wmapm || die "dobin failed."
	doman wmapm.1
	dodoc ../{BUGS,CHANGES,HINTS,README,TODO}
}
