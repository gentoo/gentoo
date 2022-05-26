# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Show hard disk activity using the scroll lock LED"
HOMEPAGE="http://members.optusnet.com.au/foonly/whirlpool/code/"
SRC_URI="mirror://gentoo/${P}.c.xz"
S="${WORKDIR}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	mv ${P}.c ${PN}.c || die
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} -o ${PN} ${PN}.c ${LDFLAGS} || die

	if use X ; then
		$(tc-getCC) ${CFLAGS} ${CPPFLAGS} -DX -lX11 -o x${PN} ${PN}.c ${LDFLAGS} || die
	fi
}

src_install() {
	dobin ${PN}

	if use X ; then
		dobin x${PN}
		elog "X version was renamed to x${PN}"
	fi
}
