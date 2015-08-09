# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
