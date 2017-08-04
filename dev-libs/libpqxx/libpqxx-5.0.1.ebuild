# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

DESCRIPTION="Standard front end for writing C++ programs that use PostgreSQL"
SRC_URI="https://github.com/jtv/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://pqxx.org/development/libpqxx/"
LICENSE="BSD"
SLOT="0"
IUSE="doc static-libs"

RDEPEND="dev-db/postgresql:="
DEPEND="${PYTHON_DEPS}
		${RDEPEND}
		doc? (
			 app-doc/doxygen
			 app-text/xmlto
		)
"

src_prepare() {
	sed -e 's/python/python2/' \
		-i tools/{splitconfig,template2mak.py} \
		|| die "Couldn't fix Python shebangs"

	eapply_user
}

src_configure() {
	local myconf
	use static-libs && myconf="--enable-static" || myconf="--enable-shared"

	econf ${myconf} $(use_enable doc documentation)
}

src_install () {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README*
	use doc && dodoc -r doc/html
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
