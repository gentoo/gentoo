# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgis/postgis-2.1.5.ebuild,v 1.2 2014/12/28 15:15:03 titanofold Exp $

EAPI="5"
POSTGRES_COMPAT=( 9.{0,1,2,3,4} )

inherit autotools eutils versionator

MY_PV=$(replace_version_separator 3 '')
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Geographic Objects for PostgreSQL"
HOMEPAGE="http://postgis.net"
SRC_URI="http://download.osgeo.org/postgis/source/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc gtk static-libs test"

RDEPEND="
		|| (
			dev-db/postgresql:9.4[server]
			dev-db/postgresql:9.3[server]
			dev-db/postgresql:9.2[server]
			dev-db/postgresql:9.1[server]
			dev-db/postgresql:9.0[server]
		)
		dev-libs/json-c
		dev-libs/libxml2:2
		>=sci-libs/geos-3.4.2
		>=sci-libs/proj-4.6.0
		>=sci-libs/gdal-1.10.0
		gtk? ( x11-libs/gtk+:2 )
"

DEPEND="${RDEPEND}
		doc? (
				app-text/docbook-xsl-stylesheets
				app-text/docbook-xml-dtd:4.5
				dev-libs/libxslt
				|| (
					media-gfx/imagemagick[png]
					media-gfx/graphicsmagick[imagemagick,png]
				)
		)
		virtual/pkgconfig
		test? ( dev-util/cunit )
"

PGIS="$(get_version_component_range 1-2)"

REQUIRED_USE="test? ( doc )"

# Needs a running psql instance, doesn't work out of the box
RESTRICT="test"

MAKEOPTS+=' -j1'

# These modules are built using the same *FLAGS that were used to build
# dev-db/postgresql. The right thing to do is to ignore the current
# *FLAGS settings.
QA_FLAGS_IGNORED="usr/lib(64)?/(rt)?postgis-${PGIS}\.so"

postgres_check_slot() {
	if ! declare -p POSTGRES_COMPAT &>/dev/null; then
		die 'POSTGRES_COMPAT not declared.'
	fi

# Don't die because we can't run postgresql-config during pretend.
[[ "$EBUILD_PHASE" = "pretend" \
	&& -z "$(which postgresql-config 2> /dev/null)" ]] && return 0

	local res=$(echo ${POSTGRES_COMPAT[@]} \
		| grep -c $(postgresql-config show 2> /dev/null) 2> /dev/null)

	if [[ "$res" -eq "0" ]] ; then
			eerror "PostgreSQL slot must be set to one of: "
			eerror "    ${POSTGRES_COMPAT[@]}"
			return 1
	fi

	return 0
}

pkg_pretend() {
	postgres_check_slot || die
}

pkg_setup() {
	postgres_check_slot || die
	export PGSLOT="$(postgresql-config show)"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.1-ldflags.patch" \
		"${FILESDIR}/${PN}-2.0-arflags.patch" \
		"${FILESDIR}/${PN}-2.1.4-pkgconfig-json.patch"

	local AT_M4DIR="macros"
	eautoreconf
}

src_configure() {
	local myargs=""
	use gtk && myargs+=" --with-gui"
	econf \
		--with-pgconfig="/usr/lib/postgresql-${PGSLOT}/bin/pg_config" \
		${myargs}
}

src_compile() {
	emake
	emake -C topology

	if use doc ; then
		emake comments
		emake cheatsheets
		emake -C doc html
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && emake DESTDIR="${D}" comments-install
	emake -C topology DESTDIR="${D}" install
	dobin ./utils/postgis_restore.pl

	dodoc CREDITS TODO loader/README.* doc/*txt

	use doc && dohtml -r doc/html/*

	docinto topology
	dodoc topology/{TODO,README}

	insinto /etc
	doins "${FILESDIR}/postgis_dbs"

	use static-libs || find "${ED}" -name '*.a' -delete
}

pkg_postinst() {
	postgresql-config update

	elog "To finish installing or updating PostGIS edit:"
	elog "    ${EROOT%/}/etc/postgis_dbs"
	elog
	elog "Then, run:"
	elog "    emerge --config =${CATEGORY}/${PF}"
}

pkg_config(){
	source "${EROOT%/}/etc/conf.d/postgresql-${PGSLOT}"
	source "${EROOT%/}/etc/postgis_dbs"
	local postgis_path="${EROOT%/}/usr/share/postgresql-${PGSLOT}/contrib/postgis-${PGIS}"

	if [[ -n ${configured} ]] ; then
		einfon "Password for PostgreSQL user '${pguser}': "
		read -s PGPASSWORD
		export PGPASSWORD
		echo
	else
		eerror "You must edit:"
		eerror "    ${EROOT%/}/etc/postgis_dbs"
		eerror "Before running 'emerge --config =${CATEGORY}/${PF}'"
		eerror
		die "Edit postgis_dbs"
	fi

	# The server we work with must be the same slot we built against.
	local server_match
	server_match=$(psql -U ${pguser} -d postgres -p ${PGPORT} \
		-Aqwtc 'SELECT version()' 2> /dev/null | grep -c "PostgreSQL ${PGSLOT}")
	if [[ $? = 0 ]] ; then
		if [[ $server_match -ne 1 ]] ; then
			unset PGPASSWORD
			eerror "Server version must be ${PGSLOT}.x"
			die "Server version isn't ${PGSLOT}.x"
		fi
	else
		unset PGPASSWORD
		eerror "Is the server running?"
		die "Couldn't connect to server."
	fi

	local retval
	safe_exit() {
		unset PGPASSWORD
		sed -e 's/\(configured\)/#\1/' -i "${EROOT%/}/etc/postgis_dbs"
		eend $retval
		eerror "All actions could not be performed."
		eerror "Read above to see what failed."
		eerror "Once you fix the issue, you'll need to edit:"
		eerror "    ${EROOT%/}/etc/postgis_dbs"
		eerror "As some things may have succeeded."
		eerror
		die "All actions could not be performed"
	}

	local db
	for db in ${databases[@]} ; do
		ebegin "Performing CREATE LANGUAGE on ${db}"
		createlang -U ${pguser} -p ${PGPORT} plpgsql ${db}
		retval=$?
		# In this case, only error code 1 is fatal
		[[ $retval == 1 ]] && safe_exit || eend 0

		ebegin "Enabling PostGIS on ${db}"
		psql -q -U ${pguser} -p ${PGPORT} -d ${db} \
			-f "${postgis_path}/postgis.sql"
		retval=$?
		[[ $retval == 0 ]] && eend 0 || safe_exit
	done

	for db in ${templates[@]} ; do
		ebegin "Creating template database '${db}'"
		createdb -p ${PGPORT} -U ${pguser} -O ${pguser} -T ${from_template} \
			${db} "PostGIS Template"
		retval=$?
		[[ $retval != 0 ]] && safe_exit

		psql -q -U ${pguser} -p ${PGPORT} -c \
			"UPDATE pg_database \
			 SET datistemplate = TRUE, datallowconn = TRUE \
			 WHERE datname = '${db}'"
		retval=$?
		[[ $retval != 0 ]] && safe_exit

		createlang -U ${pguser} -p ${PGPORT} plpgsql ${db}
		retval=$?
		# In this case, only error code 1 is fatal
		[[ $retval == 1 ]] && safe_exit

		psql -q -U ${pguser} -p ${PGPORT} -d ${db} \
			-f "${postgis_path}/postgis.sql"
		retval=$?
		[[ $retval == 0 ]] && eend 0 || safe_exit
	done

	for db in ${epsg_databases[@]} ; do
		ebegin "Adding EPSG to ${db}"
		psql -q -U ${pguser} -p ${PGPORT} -d ${db} \
			-f "${postgis_path}/spatial_ref_sys.sql"
		retval=$?
		[[ $retval == 0 ]] && eend 0 || safe_exit
	done

	for db in ${comment_databases[@]} ; do
		ebegin "Adding comments on ${db}"
		local comment_file
		for comment_file in "${postgis_path}"/*_comments.sql ; do
			psql -q -U ${pguser} -p ${PGPORT} -d ${db} -f "${comment_file}"
			retval=$?
			[[ $retval == 0 ]] && continue || safe_exit
		done
		eend 0
	done

	for db in ${upgrade_from_1_3[@]} ; do
		ebegin "Upgrading from PostGIS 1.3 to ${PGIS} on ${db}"
		psql -q -U ${pguser} -p ${PGPORT} -d ${db} \
			-f "${postgis_path}/postgis_upgrade_13_to_${PGIS//.}.sql"
		retval=$?
		[[ $retval == 0 ]] && eend 0 || safe_exit
	done

	for db in ${upgrade_from_1_4[@]} ; do
		ebegin "Upgrading from PostGIS 1.4 to ${PGIS} on ${db}"
		psql -q -U ${pguser} -p ${PGPORT} -d ${db} \
			-f "${postgis_path}/postgis_upgrade_14_to_${PGIS//.}.sql"
		retval=$?
		[[ $retval == 0 ]] && eend 0 || safe_exit
	done

	for db in ${upgrade_from_1_5[@]} ; do
		ebegin "Minor upgrade for PostGIS ${PGIS} on ${db}"
		psql -q -U ${pguser} -p ${PGPORT} -d ${db} \
			-f "${postgis_path}/postgis_upgrade_${PGIS//.}_minor.sql"
		retval=$?
		[[ $retval == 0 ]] && eend 0 || safe_exit
	done

	# Clean up and make it so the user has to edit postgis_dbs again that
	# way this script won't step on any toes due to user error.
	unset PGPASSWORD
	sed -e 's/\(configured\)/#\1/' -i "${EROOT%/}/etc/postgis_dbs"
	einfo "PostgreSQL ${PGSLOT} is now PostGIS enabled."
	einfo
	einfo "Currently, only one PostgreSQL slot at a time can be PostGIS enabled."
}
