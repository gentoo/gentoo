# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpqxx/libpqxx-4.0.1.ebuild,v 1.14 2015/04/08 17:51:55 mgorny Exp $

EAPI="4"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1

KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"

DESCRIPTION="C++ client API for PostgreSQL. The standard front-end for writing C++ programs that use PostgreSQL"
SRC_URI="http://pqxx.org/download/software/${PN}/${P}.tar.gz"
HOMEPAGE="http://pqxx.org/development/libpqxx/"
LICENSE="BSD"
SLOT="0"
IUSE="doc static-libs"

RDEPEND="dev-db/postgresql"
DEPEND="${PYTHON_DEPS}
		${RDEPEND}
"

src_prepare() {
	sed -e 's/python/python2/' \
		-i tools/{splitconfig,template2mak.py} \
		|| die "Couldn't fix Python shebangs"
}

src_configure() {
	if use static-libs ; then
		econf --enable-static
	else
		econf --enable-shared
	fi
}

src_install () {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README*
	use doc && dohtml -r doc/html/*
}

src_test() {
	einfo "The tests need a running PostgreSQL server and an existing database."
	einfo "Test requires PGDATABASE and PGUSER to be set at a minimum. Optionally,"
	einfo "set PGPORT and PGHOST. Define them at the command line or in:"
	einfo "    ${EROOT%/}/etc/libpqxx_test_env"

	if [[ -z $PGDATABASE || -z $PGUSER ]] ; then
		if [[ -f ${EROOT%/}/etc/libpqxx_test_env ]] ; then
			source "${EROOT%/}/etc/libpqxx_test_env"
			[[ -n $PGDATABASE ]] && export PGDATABASE
			[[ -n $PGHOST ]] && export PGHOST
			[[ -n $PGPORT ]] && export PGPORT
			[[ -n $PGUSER ]] && export PGUSER
		fi
	fi

	if [[ -n $PGDATABASE && -n $PGUSER ]] ; then
		local server_version
		server_version=$(psql -Aqtc 'SELECT version();' 2> /dev/null)
		if [[ $? = 0 ]] ; then
			# Currently works with highest server version in tree
			#server_version=$(echo ${server_version} | cut -d " " -f 2 | cut -d "." -f -2 | tr -d .)
			#if [[ $server_version < 92 ]] ; then
				cd "${S}/test"
				emake check
			#else
			#	eerror "Server version must be 8.4.x or below."
			#	die "Server version isn't 8.4.x or below"
			#fi
		else
			eerror "Is the server running?"
			eerror "Verify role and database exist, and are permitted in pg_hba.conf for:"
			eerror "    Role: ${PGUSER}"
			eerror "    Database: ${PGDATABASE}"
			die "Couldn't connect to server."
		fi
	else
		eerror "PGDATABASE and PGUSER must be set to perform tests."
		eerror "Skipping tests."
	fi
}
