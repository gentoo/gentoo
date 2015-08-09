# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Drop-in replacement for 'tail' which uses the kernel DNOTIFY-api"
HOMEPAGE="http://www.vanheusden.com/turbotail/"
SRC_URI="http://www.vanheusden.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="fam"

DEPEND="fam? ( virtual/fam )"
RDEPEND="${DEPEND}"

src_compile() {
	local myconf mylibs
	if use fam; then
		myconf="-DUSE_FAM"
		mylibs="-lfam"
	else
		myconf="-DUSE_DNOTIFY"
	fi

	echo "$(tc-getCC) ${CFLAGS} ${myconf} -DVERSION=\"${PV}\" -c ${PN}.c"
	$(tc-getCC) ${CFLAGS} ${myconf} -DVERSION=\"${PV}\" -c ${PN}.c || die
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.o ${mylibs}"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.o ${mylibs} || die
}

src_install() {
	dobin turbotail
	dodoc readme.txt
}
