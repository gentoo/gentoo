# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/ctdb/ctdb-1.0.114_p1.ebuild,v 1.12 2014/08/10 19:58:22 slyfox Exp $

EAPI="2"

inherit autotools rpm eutils

DESCRIPTION="A cluster implementation of the TDB database used to store temporary data"
HOMEPAGE="http://ctdb.samba.org/"
SRC_URI="http://ctdb.samba.org/packages/redhat/RHEL5/${P/_p/-}.src.rpm
	http://ctdb.samba.org/packages/redhat/RHEL5/old/${P/_p/-}.src.rpm"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="test"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}
	test? ( sys-apps/iproute2
		sys-process/procps )"

S="${WORKDIR}/${P/_p*}"

src_prepare() {
	AT_M4DIR="-I ${S}/lib/replace -I ${S}/lib/talloc -I ${S}/lib/tdb -I ${S}/lib/popt -I ${S}/lib/events"
	autotools_run_tool autoheader ${AT_M4DIR} || die "running autoheader failed"
	eautoconf ${AT_M4DIR}

	# fix tests
	sed -i \
		-e "s|/tmp|${T}|" \
		tests/simple/54_ctdb_transaction_recovery.sh || die "sed failed"

	# the following tests assume that the setup was indeed able to add new ip
	# addresses to the lo device (11,16), resp make assumptions about the
	# performance (52)
	rm \
		tests/simple/{11,16,52}_*.sh || die "removing failing tests failed"

	epatch \
		"${FILESDIR}/${PN}-50.samba_gentoo.patch" \
		"${FILESDIR}/${P}-functions.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc "${D}/usr/share/doc/ctdb/README.eventscripts"
	rm -rf "${D}/usr/share/doc/ctdb"

	dohtml web/* doc/*.html

	newinitd "${FILESDIR}/${PN}.initd" ctdb || die "newinitd failed"
	newconfd "${S}/config/ctdb.sysconfig" ctdb || die "newconfd failed"
}

src_test() {
	emake test || { pkill ctdb ; die "running tests failed" ; }
	pkill ctdb
}
