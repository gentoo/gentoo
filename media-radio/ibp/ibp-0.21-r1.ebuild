# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit toolchain-funcs

DESCRIPTION="Shows currently transmitting beacons of the International Beacon Project (IBP)"
HOMEPAGE="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${PN}.html"
SRC_URI="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="X"

RDEPEND="sys-libs/ncurses:0
	X? ( x11-libs/libX11  )"
DEPEND="${RDEPEND}
	X? ( x11-misc/imake )"

src_prepare() {
	# respect CFLAGS if built without USE=X
	sed -i -e "s/= -D/+= -D/" Makefile || die
	# fix compile if ncurses is built with separate libtinfo
	if has_version "sys-libs/ncurses:0[tinfo]" ;then
		sed -i -e "s/-lcurses/-lcurses -ltinfo/" Imakefile Makefile || die
	fi

	eapply_user
}

src_configure() {
	if use X ;then
		xmkmf || die
	fi
}

src_compile() {
	if use X ; then
		emake \
			CC="$(tc-getCC)" \
			LOCAL_LDFLAGS="${LDFLAGS}" \
			CDEBUGFLAGS="${CFLAGS}"
	else
		emake CC="$(tc-getCC)"
	fi
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
