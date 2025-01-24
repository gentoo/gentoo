# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DKIM filter for Courier-MTA"
HOMEPAGE="https://www.tana.it/sw/zdkimfilter"
SRC_URI="https://www.tana.it/sw/zdkimfilter/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="net-libs/gnutls
	mail-mta/courier
	dev-db/opendbx
	dev-libs/nettle:=
	net-dns/libidn2:=
	dev-libs/libunistring:=
	dev-libs/libbsd"
RDEPEND="${DEPEND}"

# Tests don't work with portage sandbox
RESTRICT="test"

src_configure() {
	econf $(use_enable debug)
}

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	emake DESTDIR="${D}" install
	diropts -o mail -g mail
	dodir /etc/courier/filters/keys
	dodoc release-notes-*.txt README ChangeLog
	dodoc odbx_example.{conf,sql}
}
