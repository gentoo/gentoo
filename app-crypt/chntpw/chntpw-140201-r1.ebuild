# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Offline Windows NT Password & Registry Editor"
HOMEPAGE="https://pogostick.net/~pnh/ntpasswd/"
SRC_URI="https://pogostick.net/~pnh/ntpasswd/${PN}-source-${PV}.zip"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static"

RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}
	app-arch/unzip
	static? ( dev-libs/openssl:0[static-libs] )"

DOCS=(
	HISTORY.txt
	README.txt
	WinReg.txt
	regedit.txt
)

PATCHES=(
	"${FILESDIR}"/${P}-missing-stdint.patch
)

src_prepare() {
	default
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
	einstalldocs
	dobin chntpw cpnt reged sampasswd samusrgrp

	if use static; then
		dobin {chntpw,reged,sampasswd,samusrgrp}.static
	fi
}
