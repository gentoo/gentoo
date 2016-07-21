# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

[[ ${PV} == 9999 ]] && MY_P=${PN/2/-II} || MY_P="${PN/2/-II}-${PV}"

ECVS_SERVER="cvs.pgfoundry.org:/cvsroot/pgpool"
ECVS_MODULE="pgpool-II"
[[ ${PV} == 9999 ]] && SCM_ECLASS="cvs"
inherit base user ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="Connection pool server for PostgreSQL"
HOMEPAGE="http://www.pgpool.net/"
[[ ${PV} == 9999 ]] || SRC_URI="http://www.pgpool.net/download.php?f=${MY_P}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"

IUSE="memcached pam ssl static-libs"

RDEPEND="
	dev-db/postgresql
	memcached? ( dev-libs/libmemcached )
	pam? ( sys-auth/pambase )
	ssl? ( dev-libs/openssl )
"
DEPEND="${RDEPEND}
	sys-devel/bison
	!!dev-db/pgpool
"

AUTOTOOLS_IN_SOURCE_BUILD="1"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup postgres 70
	enewuser pgpool -1 -1 -1 postgres

	# We need the postgres user as well so we can set the proper
	# permissions on the sockets without getting into fights with
	# PostgreSQL's initialization scripts.
	enewuser postgres 70 /bin/bash /var/lib/postgresql postgres
}

src_prepare() {
	epatch "${FILESDIR}/pgpool_run_paths.patch"

	local pg_config_manual="$(pg_config --includedir)/pg_config_manual.h"
	local pgsql_socket_dir=$(grep DEFAULT_PGSOCKET_DIR "${pg_config_manual}" | \
		sed 's|.*\"\(.*\)\"|\1|g')
	local pgpool_socket_dir="$(dirname $pgsql_socket_dir)/pgpool"

	sed "s|@PGSQL_SOCKETDIR@|${pgsql_socket_dir}|g" \
		-i *.conf.sample* pool.h || die

	sed "s|@PGPOOL_SOCKETDIR@|${pgpool_socket_dir}|g" \
		-i *.conf.sample* pool.h || die
}

src_configure() {
	local myconf
	use memcached && \
		myconf="--with-memcached=\"${EROOT%/}/usr/include/libmemcached\""
	use pam && myconf+=' --with-pam'

	econf \
		--disable-rpath \
		--sysconfdir="${EROOT%/}/etc/${PN}" \
		$(use_with ssl openssl) \
		$(use_enable static-libs static) \
		${myconf}
}

src_compile() {
	emake

	cd sql
	emake
}

src_install() {
	emake DESTDIR="${D}" install

	cd sql
	emake DESTDIR="${D}" install
	cd "${S}"

	# `contrib' moved to `extension' with PostgreSQL 9.1
	local pgslot=$(postgresql-config show)
	if [[ ${pgslot//.} > 90 ]] ; then
		cd "${ED%/}$(pg_config --sharedir)"
		mv contrib extension || die
		cd "${S}"
	fi

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	# Documentation
	dodoc NEWS TODO doc/where_to_send_queries.{pdf,odg}
	dohtml -r doc

	# Examples and extras
	insinto "/usr/share/${PN}"
	doins doc/{pgpool_remote_start,basebackup.sh,recovery.conf.sample}
	mv "${ED%/}/usr/share/${PN/2/-II}" "${ED%/}/usr/share/${PN}" || die

	# One more thing: Evil la files!
	find "${ED}" -name '*.la' -exec rm -f {} +
}
