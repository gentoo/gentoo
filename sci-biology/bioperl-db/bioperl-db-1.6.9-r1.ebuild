# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BIOPERL_RELEASE=1.6.9

DIST_NAME=BioPerl-DB
DIST_AUTHOR=CJFIELDS
DIST_VERSION=1.006900
inherit perl-module

DESCRIPTION="Perl tools for bioinformatics - Perl API that accesses the BioSQL schema"
HOMEPAGE="http://www.bioperl.org/"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
IUSE="test"

DIST_TEST="do" # Parallelism probably bad
PATCHES=( "${FILESDIR}/${PN}-1.6.9-db.patch" )
RDEPEND="
	>=sci-biology/bioperl-${PV}
	dev-perl/DBD-mysql
	dev-perl/DBI
	sci-biology/biosql"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Data-Stag
		dev-perl/Sub-Uplevel
		dev-perl/Test-Warn
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
src_prepare() {
	export GENTOO_DB_HOSTNAME=localhost
	perl-module_src_prepare
}
src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
}
src_test() {
	einfo "Removing bundled test libraries t/lib"
	rm -r "${S}/t/lib" || die "Cannot remove t/lib"

	ebegin "Setting up test database"

	local mysqld="${EPREFIX}/usr/sbin/mysqld"
	local socket="${T}/mysql.sock"
	local pidfile="${T}/mysql.pid"
	local datadir="${T}/mysql-data-dir"
	local mysql="${EPREFIX}/usr/bin/mysql"

	mkdir -p "${datadir}" || die "Can't make mysql database dir";
	chmod 755 "${datadir}" || die "Can't fix mysql database dir perms";

	if $mysqld --help | grep -q MariaDB ; then
		"${EPREFIX}"/usr/share/mysql/scripts/mysql_install_db \
			--basedir="${EPREFIX}/usr" \
			--datadir="${datadir}" \
			--user=$(whoami) || die "Can't initalize database"
	fi

	${mysqld} --no-defaults	--user=$(whoami) --skip-networking \
							--socket="${socket}" \
							--pid-file="${pidfile}" \
							--datadir="${datadir}" &
	maxtry=20
	while ! [[ -S "${socket}" || "${maxtry}" -lt 1 ]] ; do
		maxtry=$((${maxtry}-1))
		echo -n "."
		sleep 1
	done
	eend $?
	export MYSQL_UNIX_PORT="${socket}"
	perl-module_src_test
	ebegin "Shutting down mysql test database"
	pkill -F "${pidfile}"
	eend $?
}
