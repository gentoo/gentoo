# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://git.postgresql.org/git/pgpool2.git"

POSTGRES_COMPAT=( 9.{2..6} )

inherit git-r3 postgres-multi

DESCRIPTION="Connection pool server for PostgreSQL"
HOMEPAGE="http://www.pgpool.net/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"

KEYWORDS=""

IUSE="doc memcached pam ssl static-libs"

RDEPEND="
	${POSTGRES_DEP}
	net-libs/libnsl:0=
	memcached? ( dev-libs/libmemcached )
	pam? ( sys-auth/pambase )
	ssl? ( dev-libs/openssl:* )
"
DEPEND="${RDEPEND}
	sys-devel/bison
	!!dev-db/pgpool
"

pkg_setup() {
	postgres_new_user pgpool

	postgres-multi_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}/pgpool_run_paths-9999.patch"

	postgres-multi_src_prepare
}

src_configure() {
	local myconf
	use memcached && \
		myconf="--with-memcached=\"${EROOT%/}/usr/include/libmemcached\""
	use pam && myconf+=' --with-pam'

	postgres-multi_foreach econf \
		--disable-rpath \
		--sysconfdir="${EROOT%/}/etc/${PN}" \
		--with-pgsql-includedir='/usr/include/postgresql-@PG_SLOT@' \
		--with-pgsql-libdir="/usr/$(get_libdir)/postgresql-@PG_SLOT@/$(get_libdir)" \
		$(use_with ssl openssl) \
		$(use_enable static-libs static) \
		${myconf}
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
	if use doc ; then
		postgres-multi_forbest emake DESTDIR="${D}" -C doc install
	fi

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
