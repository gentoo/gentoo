# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="An authoritative only, high performance, open source name server"
HOMEPAGE="https://www.nlnetlabs.nl/projects/nsd"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NLnetLabs/nsd.git"
else
	# version voodoo needed only for non-release tarballs: 4.0.0_rc1 => 4.0.0rc1
	MY_PV="${PV/_beta/b}"
	MY_PV="${MY_PV/_rc/rc}"
	MY_P="${PN}-${MY_PV}"

	if [[ ${PV} != *_beta* && ${PV} != *_rc* ]] ; then
		SRC_URI="https://www.nlnetlabs.nl/downloads/${PN}/${MY_P}.tar.gz"
		S="${WORKDIR}"/${MY_P}

		KEYWORDS="~amd64 ~x86"
	fi
fi

LICENSE="BSD"
SLOT="0"
IUSE="bind8-stats debug dnstap libevent minimal-responses mmap munin +nsec3 ratelimit root-server ssl systemd"

RDEPEND="
	acct-group/nsd
	acct-user/nsd
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c
	)
	libevent? ( dev-libs/libevent )
	munin? ( net-analyzer/munin )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	systemd? ( virtual/pkgconfig )
"

PATCHES=(
	# Fix the paths in the munin plugin to match our install
	"${FILESDIR}"/nsd_munin_.patch
	"${FILESDIR}"/${P}-implausible-stats.patch
)

src_prepare() {
	default

	# Required to get correct pkg-config macros with USE="systemd"
	# See bugs #663618 and #758050
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-ipv6
		--enable-largefile
		--enable-pie
		--enable-relro-now
		--enable-tcp-fastopen

		--with-dbfile="${EPREFIX}"/var/db/nsd/nsd.db
		--with-logfile="${EPREFIX}"/var/log/nsd.log
		--with-pidfile="${EPREFIX}"/run/nsd/nsd.pid
		--with-xfrdfile="${EPREFIX}"/var/db/nsd/xfrd.state
		--with-xfrdir="${EPREFIX}"/var/db/nsd
		--with-zonelistfile="${EPREFIX}"/var/db/nsd/zone.list
		--with-zonesdir="${EPREFIX}"/var/lib/nsd

		$(use_enable bind8-stats)
		$(use_enable bind8-stats zone-stats)
		$(use_enable debug checking)
		$(use_enable dnstap)
		$(use_enable minimal-responses)
		$(use_enable mmap)
		$(use_enable nsec3)
		$(use_enable ratelimit)
		$(use_enable root-server)
		$(use_enable systemd)
		$(use_with libevent)
		$(use_with ssl)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc doc/{ChangeLog,CREDITS,NSD-4-features,NSD-FOR-BIND-USERS,README,RELNOTES,REQUIREMENTS}

	newinitd "${FILESDIR}"/nsd.initd-r1 nsd

	# Install munin plugin and config
	if use munin ; then
		exeinto /usr/libexec/munin/plugins
		doexe contrib/nsd_munin_
		insinto /etc/munin/plugin-conf.d
		newins "${FILESDIR}"/nsd.munin-conf nsd_munin
	fi

	systemd_dounit "${FILESDIR}"/nsd.service

	# Remove the /run directory that usually resides on tmpfs and is
	# being taken care of by the nsd init script anyway (checkpath)
	rm -r "${ED}"/run || die "Failed to remove /run"

	keepdir /var/db/${PN}
}

pkg_postinst() {
	# database directory, writable by nsd for database updates and zone transfers
	install -d -m 750 -o nsd -g nsd "${EROOT}"/var/db/nsd

	# zones directory, writable by nsd for zone file updates (nsd-control write)
	install -d -m 750 -o nsd -g nsd "${EROOT}"/var/lib/nsd
}
