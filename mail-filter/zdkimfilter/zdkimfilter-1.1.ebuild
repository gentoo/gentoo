# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
DESCRIPTION="DKIM filter for Courier-MTA"
HOMEPAGE="http://www.tana.it/sw/zdkimfilter"
SRC_URI="http://www.tana.it/sw/zdkimfilter/${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opendbx"

DEPEND=">=mail-filter/opendkim-2.2.0
		mail-mta/courier
		opendbx? ( >=dev-db/opendbx-1.4.0 )
		dev-libs/nettle"
RDEPEND="${DEPEND}"

src_prepare() {
	if ! use opendbx; then
		# remove opendbx stuff
		sed -i -e '12342,12450d' configure || die
	fi
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install
	rm "${D}"/etc/courier/filters/zdkimfilter.conf || die
	diropts -o mail -g mail
	dodir /etc/courier/filters/keys
	dodoc release-notes-*.txt
	dodoc odbx_example.{conf,sql}
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} == 0.5 ]]; then
		ewarn "Database access is now through opendbx.  Please see the"
		ewarn "zfilter_db man page and example config files in"
		ewarn "\t/usr/share/doc/${P}"
		ewarn "Some config file options have changed.  Please see the"
		ewarn "release-notes."
	fi
}
