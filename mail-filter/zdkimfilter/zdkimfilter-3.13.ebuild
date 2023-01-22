# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="DKIM filter for Courier-MTA"
HOMEPAGE="https://www.tana.it/sw/zdkimfilter"
SRC_URI="https://www.tana.it/sw/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="
	dev-db/opendbx
	dev-libs/libunistring:=
	dev-libs/nettle:=
	mail-filter/opendkim
	mail-mta/courier
	net-dns/libidn2:=
"
RDEPEND="${DEPEND}"

# For working tests we need a fix for opendkim,
# see https://bugs.gentoo.org/700174
RESTRICT="test"

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install
	diropts -o mail -g mail
	dodir /etc/courier/filters/keys
	dodoc release-notes-*.txt README ChangeLog
	dodoc odbx_example.{conf,sql}
}
