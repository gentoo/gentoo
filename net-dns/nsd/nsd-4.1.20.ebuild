# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user systemd

# version voodoo needed only for non-release tarballs: 4.0.0_rc1 => 4.0.0rc1
MY_PV="${PV/_rc/rc}"
MY_PV="${MY_PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="An authoritative only, high performance, open source name server"
HOMEPAGE="http://www.nlnetlabs.nl/projects/nsd"
SRC_URI="http://www.nlnetlabs.nl/downloads/${PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bind8-stats ipv6 libevent minimal-responses mmap munin +nsec3 ratelimit root-server runtime-checks ssl libressl"

S="${WORKDIR}/${MY_P}"

RDEPEND="
	virtual/yacc
	libevent? ( dev-libs/libevent )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	munin? ( net-analyzer/munin )
"
DEPEND="
	${RDEPEND}
	sys-devel/flex
"

src_prepare() {
	# Fix the paths in the munin plugin to match our install
	eapply "${FILESDIR}"/nsd_munin_.patch
	eapply_user
}

src_configure() {
	local myeconfargs=(
		--enable-pie
		--enable-relro-now
		--enable-largefile
		--with-logfile="${EPREFIX}"/var/log/nsd.log
		--with-pidfile="${EPREFIX}"/run/nsd/nsd.pid
		--with-dbfile="${EPREFIX}"/var/db/nsd/nsd.db
		--with-xfrdir="${EPREFIX}"/var/db/nsd
		--with-xfrdfile="${EPREFIX}"/var/db/nsd/xfrd.state
		--with-zonelistfile="${EPREFIX}"/var/db/nsd/zone.list
		--with-zonesdir="${EPREFIX}"/var/lib/nsd
		$(use_enable bind8-stats)
		$(use_enable bind8-stats zone-stats)
		$(use_enable ipv6)
		$(use_enable minimal-responses)
		$(use_enable mmap)
		$(use_enable nsec3)
		$(use_enable ratelimit)
		$(use_enable root-server)
		$(use_enable runtime-checks checking)
		$(use_with libevent)
		$(use_with ssl)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc doc/{ChangeLog,CREDITS,NSD-4-features,NSD-FOR-BIND-USERS,README,RELNOTES,REQUIREMENTS}

	newinitd "${FILESDIR}"/nsd.initd-r1 nsd

	# install munin plugin and config
	if use munin ; then
		exeinto /usr/libexec/munin/plugins
		doexe contrib/nsd_munin_
		insinto /etc/munin/plugin-conf.d
		newins "${FILESDIR}"/nsd.munin-conf nsd_munin
	fi

	systemd_dounit "${FILESDIR}"/nsd.service

	# remove the /run directory that usually resides on tmpfs and is
	# being taken care of by the nsd init script anyway (checkpath)
	rm -r "${ED%/}"/run || die "Failed to remove /run"
}

pkg_postinst() {
	# Do this in postinst to ensure the uid/gid is consistent for binpkgs
	enewgroup nsd
	enewuser nsd -1 -1 -1 nsd

	# database directory, writable by nsd for database updates and zone transfers
	install -d -m 750 -o nsd -g nsd "${EROOT%/}"/var/db/nsd

	# zones directory, writable by nsd for zone file updates (nsd-control write)
	install -d -m 750 -o nsd -g nsd "${EROOT%/}"/var/lib/nsd
}
