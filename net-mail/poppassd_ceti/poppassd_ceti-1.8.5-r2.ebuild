# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs pam portability

MY_PN="poppassd"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Password change daemon with PAM support"
HOMEPAGE="http://echelon.pl/pubs/poppassd.html"
SRC_URI="http://echelon.pl/pubs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/pam"

RDEPEND="${DEPEND}
	sys-apps/xinetd"

src_compile() {
	$(tc-getCC) -c ${CFLAGS} ${MY_PN}.c || die "Compile failed."
	$(tc-getCC) ${LDFLAGS} -o poppassd ${MY_PN}.o -lpam $(dlopen_lib) || die "Linking failed."
}

src_install() {
	dodoc README

	pamd_mimic_system poppassd auth account password

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/poppassd.xinetd poppassd

	insinto /usr/sbin
	insopts -o root -g bin -m 500
	doins poppassd || die "Install failed."
}
