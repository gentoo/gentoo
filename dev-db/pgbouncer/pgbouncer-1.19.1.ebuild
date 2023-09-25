# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Lightweight connection pooler for PostgreSQL"
HOMEPAGE="https://www.pgbouncer.org/"
SRC_URI="https://www.pgbouncer.org/downloads/files/${PV}/pgbouncer-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+c-ares debug doc pam ssl systemd udns"

# At-most-one-of, one can be enabled but not both
REQUIRED_USE="?? ( c-ares udns )"

RDEPEND="
	>=dev-libs/libevent-2.0:=
	>=sys-libs/glibc-2.10
	acct-user/pgbouncer
	c-ares? ( >=net-dns/c-ares-1.10 )
	ssl? ( >=dev-libs/openssl-1.0.1:=[-bindist(-)] )
	systemd? ( sys-apps/systemd )
	udns? ( >=net-libs/udns-0.1 )
"

DEPEND="${RDEPEND}"

# Tests require a local database server, wants to fiddle with iptables,
# and doesn't support overriding.
RESTRICT="test"

src_prepare() {
	eapply "${FILESDIR}"/pgbouncer-1.12-dirs.patch

	default
}

src_configure() {
	# --enable-debug is only used to disable stripping
	econf \
		--docdir=/usr/share/doc/${PF} \
		--enable-debug \
		$(use_with c-ares cares) \
		$(use_enable debug cassert) \
		$(use_with pam) \
		$(use_with ssl openssl) \
		$(use_with systemd) \
		$(use_with udns)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS
	use doc && dodoc doc/*.md

	newconfd "${FILESDIR}/${PN}.confd-r1" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd-r2" "${PN}"

	insinto /etc
	doins etc/pgbouncer.ini

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate" pgbouncer
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		einfo "Please read the config.txt for Configuration Directives"
		einfo
		einfo "For Administration Commands, see:"
		einfo "    man pgbouncer"
		einfo
		einfo "By default, PgBouncer does not have access to any database."
		einfo "GRANT the permissions needed for your application and make sure that it"
		einfo "exists in PgBouncer's auth_file."
	fi
}
