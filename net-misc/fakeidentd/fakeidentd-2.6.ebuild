# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/fakeidentd/fakeidentd-2.6.ebuild,v 1.10 2013/08/03 06:56:04 ago Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A static, secure identd.  One source file only!"
HOMEPAGE="http://www.guru-group.fi/~too/sw/"
SRC_URI="http://www.guru-group.fi/~too/sw/identd.readme -> ${P}.readme
	http://www.guru-group.fi/~too/sw/releases/identd.c -> ${P}.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ppc64 ~sh sparc x86"
IUSE=""

echoit() {
	echo "$@"
	"$@"
}

src_unpack() {
	mkdir -p "${S}"
	echoit cp "${DISTDIR}"/${P}.{c,readme} "${S}" || die
}

src_compile() {
	echoit $(tc-getCC) ${CFLAGS} ${LDFLAGS} \
		-DTRG=\"${PN}\" -DUSE_UNIX_OS -DVERSION=\"${PV}\" \
		-o ${PN} ${P}.c || die
}

src_install() {
	dosbin ${PN} || die
	newdoc ${P}.readme identd.readme

	newinitd "${FILESDIR}"/fakeidentd.rc fakeidentd
	newconfd "${FILESDIR}"/fakeidentd.confd fakeidentd
}
