# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="WindowMaker DockApp: Battery/Power status monitor for laptops"
HOMEPAGE="http://www.dockapps.net/wmapm"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

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
