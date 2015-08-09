# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="drop-in replacement for 'tail' which uses the kernel DNOTIFY-api"
HOMEPAGE="http://www.vanheusden.com/turbotail/"
SRC_URI="http://www.vanheusden.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 hppa ~ppc ~sparc ~x86"
IUSE="fam"

DEPEND="fam? ( virtual/fam )"
RDEPEND="${DEPEND}"

src_compile() {
	local myconf
	if use fam; then
		myconf="-DUSE_FAM -lfam"
	else
		myconf="-DUSE_DNOTIFY"
	fi

	echo "$(tc-getCC) ${myconf} -DVERSION=\"${PV}\" ${PN}.c -o ${PN}"
	$(tc-getCC) ${myconf} -DVERSION=\"${PV}\" ${PN}.c -o ${PN} \
		|| die "compile failed"
}

src_install() {
	dobin turbotail || die "install failed"
	dodoc readme.txt
}
