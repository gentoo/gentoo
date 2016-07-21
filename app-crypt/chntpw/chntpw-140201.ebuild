# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Offline Windows NT Password & Registry Editor"
HOMEPAGE="http://pogostick.net/~pnh/ntpasswd/"
SRC_URI="http://pogostick.net/~pnh/ntpasswd/${PN}-source-${PV}.zip"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libressl static"

RDEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}
	app-arch/unzip
	static? ( dev-libs/openssl:0[static-libs] )"

src_prepare() {
	sed -i -e '/-o/s:$(CC):$(CC) $(LDFLAGS):' Makefile || die

	if ! use static ; then
		sed -i -e "/^all:/s/ \(chntpw\|reged\).static//g" Makefile || die
	fi

	emake clean
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -DUSEOPENSSL -Wall" \
		LIBS="-lcrypto"
}

src_install() {
	dobin chntpw cpnt reged

	if use static; then
		dobin {chntpw,reged}.static
	fi

	dodoc {HISTORY,README,regedit,WinReg}.txt
}
