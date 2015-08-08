# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs eutils

DESCRIPTION="Simple memory dumper for UNIX-Like systems"
HOMEPAGE="http://www.porcupine.org/forensics"
SRC_URI="http://www.porcupine.org/forensics/${P}.tar.gz"

LICENSE="IBM"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_prepare() {
	sed -i -e 's:$(CFLAGS):\0 $(LDFLAGS):' Makefile || die
	epatch "${FILESDIR}"/${P}-linux3.patch
}

src_compile() {
	emake CC="$(tc-getCC)" XFLAGS="${CFLAGS}" OPT= DEBUG=
}

src_test() {
	if [[ ${EUID} -ne 0 ]];
	then
		einfo "Cannot test with FEATURES=userpriv"
	elif [ -x /bin/wc ];
	then
		einfo "testing"
		if [ "`./memdump -s 344 | wc -c`" = "344" ];
		then
			einfo "passed test"
		else
			die "failed test"
		fi
	fi
}

src_install() {
	dosbin memdump
	dodoc README
	doman memdump.1
}
