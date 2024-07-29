# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://git.postgresql.org/git/pgpool2.git"

POSTGRES_COMPAT=( 9.6 {10..15} )

inherit autotools flag-o-matic git-r3 postgres-multi

DESCRIPTION="Connection pool server for PostgreSQL"
HOMEPAGE="https://www.pgpool.net/"

LICENSE="BSD"
SLOT="0"
IUSE="doc memcached pam ssl static-libs"

RDEPEND="
	${POSTGRES_DEP}
	acct-group/postgres
	acct-user/pgpool
	net-libs/libnsl:0=
	virtual/libcrypt:=
	memcached? ( dev-libs/libmemcached )
	pam? ( sys-auth/pambase )
	ssl? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}
	sys-devel/bison
	virtual/pkgconfig
	doc? (
		app-text/openjade
		dev-libs/libxml2
		dev-libs/libxslt
	)
"

pkg_setup() {
	postgres-multi_pkg_setup
}

src_prepare() {
	eapply \
		"${FILESDIR}/pgpool-4.2.0-configure-memcached.patch" \
		"${FILESDIR}/pgpool-configure-pam.patch" \
		"${FILESDIR}/pgpool-4.2.0-configure-pthread.patch" \
		"${FILESDIR}/pgpool-9999-run_paths.patch"

	eautoreconf

	postgres-multi_src_prepare
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/855248
	# https://github.com/pgpool/pgpool2/issues/42
	#
	filter-lto

	postgres-multi_foreach econf \
		--disable-rpath \
		--sysconfdir="${EPREFIX}/etc/${PN}" \
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
	use doc && postgres-multi_forbest emake -C doc
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
	use doc && postgres-multi_forbest emake DESTDIR="${D}" -C doc install

	# mv some files that get installed to /usr/share/pgpool-II so that
	# they all wind up in the same place
	mv "${ED}/usr/share/${PN/2/-II}" "${ED}/usr/share/${PN}" || die

	# One more thing: Evil la files!
	find "${ED}" -name '*.la' -exec rm -f {} +
}
