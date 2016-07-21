# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit user

DESCRIPTION="An authoritative only, high performance, open source name server"
HOMEPAGE="http://www.nlnetlabs.nl/projects/nsd"
MY_PV=${PV/_rc/rc}
MY_PV=${MY_PV/_beta/b}
MY_P=${PN}-${MY_PV}
S="${WORKDIR}/${MY_P}"
SRC_URI="http://www.nlnetlabs.nl/downloads/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bind8-stats ipv6 minimal-responses mmap +nsec3 ratelimit root-server runtime-checks zone-stats"

RDEPEND="
	dev-libs/openssl:0=
	virtual/yacc
"
DEPEND="
	${RDEPEND}
	sys-devel/flex
"

pkg_setup() {
	enewgroup nsd
	enewuser nsd -1 -1 -1 nsd
}

src_configure() {
	# ebuild.sh sets localstatedir to /var/lib, but nsd expects /var in several locations
	# some of these cannot be changed by arguments to econf/configure, f.i. logfile
	econf \
		--localstatedir="${EPREFIX}/var" \
		--with-pidfile="${EPREFIX}/var/run/nsd/nsd.pid" \
		--with-zonesdir="${EPREFIX}/var/lib/nsd" \
		--enable-largefile \
		$(use_enable bind8-stats) \
		$(use_enable ipv6) \
		$(use_enable minimal-responses) \
		$(use_enable mmap) \
		$(use_enable nsec3) \
		$(use_enable ratelimit) \
		$(use_enable root-server) \
		$(use_enable runtime-checks checking) \
		$(use_enable zone-stats)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc doc/{ChangeLog,CREDITS,NSD-FOR-BIND-USERS,README,RELNOTES,REQUIREMENTS}

	insinto /usr/share/nsd
	doins contrib/nsd.zones2nsd.conf

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/nsd3-patch.cron nsd-patch.cron

	newinitd "${FILESDIR}"/nsd3.initd-r1 nsd

	# database directory, writable by nsd for database updates and zone transfers
	dodir /var/db/nsd
	fowners nsd:nsd /var/db/nsd
	fperms 750 /var/db/nsd

	# zones directory, writable by root for 'nsdc patch'
	dodir /var/lib/nsd
	fowners root:nsd /var/lib/nsd
	fperms 750 /var/lib/nsd

	# remove /var/run data created by Makefile, handled by initd script
	rm -r "${ED}"/var/run || die "could not remove /var/run/ directory"

}
