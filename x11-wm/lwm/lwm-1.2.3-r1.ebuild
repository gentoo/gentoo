# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="The ultimate lightweight window manager"
SRC_URI="http://www.jfc.org.uk/files/lwm/${P}.tar.gz"
HOMEPAGE="http://www.jfc.org.uk/software/lwm.html"

KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
"

DEPEND="
	${RDEPEND}
	x11-misc/imake
	x11-proto/xextproto
	x11-proto/xproto
"

DOCS=( AUTHORS BUGS ChangeLog )

src_prepare() {
	default
	sed -i -e "s#(SMLIB)#& -lICE#g" Imakefile || die #370127
	xmkmf || die
}

src_compile() {
	emake \
		EXTRA_LDOPTIONS="${CFLAGS} ${LDFLAGS}" \
		CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)" \
		"${PN}"
}

src_install() {
	dobin "${PN}"
	newman "${PN}.man" "${PN}.1"
	einstalldocs
}
