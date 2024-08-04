# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools systemd tmpfiles

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
IUSE="bind8-stats debug +default-znow dnstap +ipv6 +largefile libevent +lto memclean minimal-responses mmap munin +nsec3 packed +pie +radix-tree ratelimit recvmmsg +simdzone ssl systemd +tfo year2038"

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
	"${FILESDIR}/${PN}-munin-gentoo-paths.patch"
)

NSD_TMPFILESD_VER="1"		# Cur version of NSD's tmpfiles.d config.

NSD_DBDIR="/var/db/nsd"		# Default dir for NSD's databases.
NSD_ZNDIR="/var/lib/nsd"	# Default dir for NSD's zone files.

src_prepare() {
	default

	# Required to get correct pkg-config macros with USE="systemd".
	# See bugs #663618 & #758050.
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable bind8-stats)
		$(use_enable bind8-stats zone-stats)
		$(use_enable debug checking)
		$(use_enable default-znow relro-now)
		$(use_enable dnstap)
		$(use_enable ipv6)
		$(use_enable largefile)
		$(use_enable lto flto)
		$(use_enable memclean)
		$(use_enable minimal-responses)
		$(use_enable mmap)
		$(use_enable nsec3)
		$(use_enable packed)
		$(use_enable pie)
		$(use_enable radix-tree)
		$(use_enable ratelimit)
		$(use_enable recvmmsg)
		$(use_enable systemd)
		$(use_enable tfo tcp-fastopen)
		$(use_with libevent)
		$(use_with ssl)

		--with-dbfile="${EPREFIX}${NSD_DBDIR}/nsd.db"
		--with-logfile="${EPREFIX}/var/log/nsd.log"
		--with-pidfile="${EPREFIX}/run/nsd.pid"
		--with-xfrdfile="${EPREFIX}${NSD_DBDIR}/xfrd.state"
		--with-xfrdir="${EPREFIX}${NSD_DBDIR}"
		--with-zonelistfile="${EPREFIX}${NSD_DBDIR}/zone.list"
		--with-zonesdir="${EPREFIX}${NSD_ZNDIR}"
	)

	# NSD 4.10.x introduced a new zone parser, "simdzone", which
	# replaces the older parser that used flex & bison:
	#   https://github.com/NLnetLabs/simdzone
	# It leverages SSE4.2 and/or AVX2 instruction sets for faster
	# zone parsing on x86_64 architectures.  Other CPU archs will
	# use a fallback implementation.
	if use amd64; then
		myconf+=(
			$(use_enable simdzone haswell)
			$(use_enable simdzone westmere)
		)
	fi

	# This configure switch only appears on glibc-based userlands.
	# It enables 64-bit time_t to support timestamps greater than
	# the year 2038 (D_TIME_BITS=64).
	if use elibc_glibc; then
		myconf+=( $(use_enable year2038) )
	fi

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc doc/{ChangeLog,CREDITS,NSD-4-features,NSD-FOR-BIND-USERS,README,RELNOTES,REQUIREMENTS}
	newinitd "contrib/nsd.openrc.in" nsd
	newconfd "contrib/nsd.openrc.conf" nsd
	newtmpfiles "${FILESDIR}/nsd.tmpfilesd-r${NSD_TMPFILESD_VER}" nsd.conf

	# Install munin plugin and config, if requested.
	if use munin ; then
		exeinto "/usr/libexec/munin/plugins"
		doexe "contrib/nsd_munin_"
		insinto "/etc/munin/plugin-conf.d"
		newins "${FILESDIR}/nsd.munin-conf" nsd_munin
	fi

	# Use the upstream-provided systemd service file.
	systemd_dounit "contrib/nsd.service"

	# Remove the /run directory that usually resides on tmpfs and is
	# being taken care of by the nsd init script anyway (checkpath).
	rm -r "${ED}/run" || die "Failed to remove /run"

	keepdir "${NSD_DBDIR}"
}

pkg_postinst() {
	# See eclass/tmpfiles.eclass for info.
	tmpfiles_process nsd.conf

	# Database directory
	# Writable by nsd:nsd for database updates and zone transfers.
	install -d -m 750 -o nsd -g nsd "${EROOT}/${NSD_DBDIR}"

	# Zones directory
	# Writable by nsd:nsd for zone file updates (via 'nsd-control write').
	install -d -m 750 -o nsd -g nsd "${EROOT}/${NSD_ZNDIR}"
}
