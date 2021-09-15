# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tool for checking well known weaknesses in the TCP/IP protocol"
HOMEPAGE="http://lin.fsid.cvut.cz/~kra/index.html"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-$(ver_cut 4).$(ver_cut 6).diff.gz"
S="${WORKDIR}/${P/_p*}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

PATCHES=(
	"${WORKDIR}"/${PN}_1.5-6.1.diff
	"${FILESDIR}"/${P/_p*}-exit.patch
	"${FILESDIR}"/${P/_p*}-gentoo.patch
	"${FILESDIR}"/${P/_p*}-log2.patch
	"${FILESDIR}"/${P/_p*}-tpserv-log.patch
)

src_configure() {
	append-cppflags -DSYNC_FAST
}

src_compile() {
	local target
	for target in . tpserv; do
		emake CC=$(tc-getCC) LDFLAGS="${CFLAGS} ${LDFLAGS}" -C "${target}"
	done
}

src_install() {
	dosbin hunt tpserv/tpserv tpsetup/transproxy
	doman man/hunt.1
	dodoc CHANGES README* TODO tpsetup/transproxy
	newdoc debian/changelog debian.changelog
}
