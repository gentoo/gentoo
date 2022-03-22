# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools db-use

DESCRIPTION="Combined filter, redirector and access controller plugin for Squid"
HOMEPAGE="http://www.squidguard.org"
SRC_URI="mirror://debian/pool/main/s/squidguard/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 ~sparc x86"

IUSE="ldap"

RDEPEND="
	acct-group/squid
	acct-user/squid
	|| (
		sys-libs/db:5.3
		sys-libs/db:4.8
	)
	ldap? ( net-nds/openldap:= )"

DEPEND="${RDEPEND}"

BDEPEND="
	sys-devel/bison:0
	sys-devel/flex:0
"

suitable_db_version() {
	local tested_slots="5.3 4.8"
	for ver in ${tested_slots}; do
		if [[ -n $(db_findver sys-libs/db:${ver}) ]]; then
			echo ${ver}
			return 0
		fi
	done
	die "No suitable BerkDB versions found, aborting"
}

src_prepare() {
	eapply \
		"${FILESDIR}/${P}-gentoo.patch" \
		"${FILESDIR}/${P}-gcc-10.patch"

	# Link only with specific BerkDB versions
	# Do not inject default paths for library searching
	db_version="$(suitable_db_version)"
	sed -i \
		-e "/\$LIBS -ldb/s/-ldb/-l$(db_libname ${db_version})/" \
		-e '/$LDFLAGS $db_lib $ldap_lib/d' \
		configure.ac || die

	eapply_user
	eautoreconf

	# Workaround for missing install-sh, bug #705374
	local amver=$(best_version sys-devel/automake)
	amver=$(ver_cut 1-2 "${amver#sys-devel/automake-}")
	cp -p "${BROOT}/usr/share/automake-${amver}/install-sh" . || die
}

src_configure() {
	econf \
		$(use_with ldap) \
		--with-db-inc="$(db_includedir ${db_version})" \
		--with-sg-config=/etc/squidGuard/squidGuard.conf \
		--with-sg-logdir=/var/log/squidGuard
}

src_install() {
	emake prefix="/usr" DESTDIR="${D}" install

	keepdir /var/log/squidGuard
	fowners squid:squid /var/log/squidGuard

	insinto /etc/squidGuard/sample
	doins "${FILESDIR}"/squidGuard.conf.*
	insinto /etc/squidGuard/sample/db
	doins "${FILESDIR}"/blockedsites

	dodoc ANNOUNCE CHANGELOG README
	docinto html
	dodoc doc/*.html
	docinto text
	dodoc doc/*.txt
}

pkg_postinst() {
	einfo "To enable squidGuard, add the following lines to /etc/squid/squid.conf:"
	einfo "    url_rewrite_program /usr/bin/squidGuard"
	einfo "    url_rewrite_children 10"
	einfo ""
	einfo "Remember to edit /etc/squidGuard/squidGuard.conf first!"
	einfo "Examples can be found in /etc/squidGuard/sample/"
}
