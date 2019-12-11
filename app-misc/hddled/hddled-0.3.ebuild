# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Show hard disk activity using the scroll lock LED"
HOMEPAGE="http://members.optusnet.com.au/foonly/whirlpool/code/"
SRC_URI="mirror://gentoo/${P}.c.xz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	mv ${P}.c ${PN}.c || die
}

src_compile() {
	$(tc-getCC) ${CFLAGS} -o ${PN} ${PN}.c ${LDFLAGS} || die
	if use X ; then
		$(tc-getCC) ${CFLAGS} -DX -lX11 -o x${PN} ${PN}.c ${LDFLAGS} || die
	fi
}

src_install() {
	dobin ${PN}
	if use X ; then
		dobin x${PN}
		elog "X version was renamed to x${PN}"
	fi
}
