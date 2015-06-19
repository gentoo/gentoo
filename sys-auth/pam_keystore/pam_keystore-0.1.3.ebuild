# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_keystore/pam_keystore-0.1.3.ebuild,v 1.2 2014/05/08 22:29:04 vapier Exp $

inherit pam toolchain-funcs

DESCRIPTION="Keeps a login and the password the user in the kernel"
HOMEPAGE="http://www.calculate-linux.org/main/en/pam_keystore"
SRC_URI="ftp://ftp.calculate.ru/pub/calculate/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/pam
	>=sys-apps/keyutils-1.1"
RDEPEND="${DEPEND}"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD_D="$(tc-getCC) -shared ${LDFLAGS}" \
		CFLAGS="-fPIC ${CFLAGS}" \
		SHARE= \
		|| die "make failed"
}

src_install() {
	dopammod pam_keystore.so || die
	newdoc README README.ru || die
}
