# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A DNS-Server which gets its data from a MySQL/PostgreSQL-database"
HOMEPAGE="http://www.mydns.pl/"
SRC_URI="mirror://sourceforge/mydns-ng/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc x86"
IUSE="alias debug nls mysql postgres ssl static status"

BDEPEND="sys-devel/bison"
RDEPEND="
	virtual/libiconv
	mysql? ( dev-db/mysql-connector-c:= )
	nls? ( virtual/libintl )
	postgres? ( dev-db/postgresql )
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="
	${RDEPEND}
	nls? ( >=sys-devel/gettext-0.12 )
"

REQUIRED_USE="^^ ( mysql postgres )"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.8.27-m4.patch"
	"${FILESDIR}/${P}-texinfo.patch"
	"${FILESDIR}/${PN}-1.2.8.31-ssl-libdir.patch"
	"${FILESDIR}/${PN}-1.2.8.31-misc-libdir.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #775134
	append-flags -fcommon

	econf \
		$(use_enable alias) \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_enable static) \
		$(use_enable static static-build) \
		$(use_enable status) \
		$(use_with ssl openssl) \
		--without-included-gettext
}

src_install() {
	default

	dodoc AUTHORS BUGS ChangeLog QUICKSTART* NEWS README* TODO
	docinto contrib
	dodoc contrib/*.php contrib/*.pl contrib/*.pm contrib/README*

	newinitd "${FILESDIR}/mydns.initd" mydns
	newconfd "${FILESDIR}/mydns.confd" mydns

	## Avoid file collision
	rm -f "${ED}/usr/share/locale/locale.alias"

	# Install config file
	insinto /etc
	newins mydns.conf mydns.conf
	fowners root:root /etc/mydns.conf
	fperms 0600 /etc/mydns.conf
}

pkg_postinst() {
	if use postgres; then
		elog "# createdb mydns"
		elog "# /usr/sbin/mydns --create-tables | psql mydns"
		elog
		elog "to create the tables in the PostgreSQL-Database."
		elog "For more info see QUICKSTART.postgres."
	fi
	if use mysql; then
		elog "# mysqladmin -u <useruname> -p create mydns"
		elog "# /usr/sbin/mydns --create-tables | mysql -u <username> -p mydns"
		elog
		elog "to create the tables in the MySQL-Database."
		elog "For more info see QUICKSTART.mysql."
	fi
	elog
}
