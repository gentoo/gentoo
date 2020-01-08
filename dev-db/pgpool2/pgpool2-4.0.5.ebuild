# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.{4..6} {10..11} )

inherit autotools postgres-multi

MY_P="${PN/2/-II}-${PV}"

DESCRIPTION="Connection pool server for PostgreSQL"
HOMEPAGE="https://www.pgpool.net/"
SRC_URI="https://www.pgpool.net/download.php?f=${MY_P}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 x86"

IUSE="doc libressl memcached pam ssl static-libs"

RDEPEND="
	${POSTGRES_DEP}
	net-libs/libnsl:0=
	memcached? ( dev-libs/libmemcached )
	pam? ( sys-auth/pambase )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${RDEPEND}
	!!dev-db/pgpool
	sys-devel/bison
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	postgres_new_user pgpool

	postgres-multi_pkg_setup
}

src_prepare() {
	eapply \
		"${FILESDIR}/pgpool-configure-memcached.patch" \
		"${FILESDIR}/pgpool-configure-pam.patch" \
		"${FILESDIR}/pgpool-configure-pthread.patch" \
		"${FILESDIR}/pgpool_run_paths-3.7.10.patch"

	eautoreconf

	postgres-multi_src_prepare
}

src_configure() {
	postgres-multi_foreach econf \
		--disable-rpath \
		--sysconfdir="${EROOT%/}/etc/${PN}" \
		--with-pgsql-includedir='/usr/include/postgresql-@PG_SLOT@' \
		--with-pgsql-libdir="/usr/$(get_libdir)/postgresql-@PG_SLOT@/$(get_libdir)" \
		$(use_enable static-libs static) \
		$(use_with memcached) \
		$(use_with pam) \
		$(use_with ssl openssl)
}

src_compile() {
	# Even though we're only going to do an install for the best slot
	# available, the extension bits in src/sql need some things outside
	# of that directory built, too.
	postgres-multi_foreach emake
	postgres-multi_foreach emake -C src/sql
}

src_install() {
	# We only need the best stuff installed
	postgres-multi_forbest emake DESTDIR="${D}" install

	# Except for the extension and .so files that each PostgreSQL slot needs
	postgres-multi_foreach emake DESTDIR="${D}" -C src/sql install

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	# Documentation!
	dodoc NEWS TODO
	doman doc/src/sgml/man{1,8}/*
	use doc && dodoc -r doc/src/sgml/html

	# Examples and extras
	# mv some files that get installed to /usr/share/pgpool-II so that
	# they all wind up in the same place
	mv "${ED%/}/usr/share/${PN/2/-II}" "${ED%/}/usr/share/${PN}" || die
	into "/usr/share/${PN}"
	dobin src/sample/{pgpool_recovery,pgpool_recovery_pitr,pgpool_remote_start}
	insinto "/usr/share/${PN}"
	doins src/sample/{{pcp,pgpool,pool_hba}.conf.sample*,pgpool.pam}

	# One more thing: Evil la files!
	find "${ED}" -name '*.la' -exec rm -f {} +
}
