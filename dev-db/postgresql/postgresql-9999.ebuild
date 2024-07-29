# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12,13} )
LLVM_COMPAT=( {15..18} )
LLVM_OPTIONAL=1

inherit flag-o-matic linux-info llvm-r1 meson pam python-single-r1 \
		systemd tmpfiles

DESCRIPTION="PostgreSQL RDBMS"
HOMEPAGE="https://www.postgresql.org/"
LICENSE="POSTGRESQL GPL-2"

SLOT=$(ver_cut 1)

if [[ $PV = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.postgresql.org/git/postgresql.git"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

	MY_PV=${PV/_/}
	SRC_URI="https://ftp.postgresql.org/pub/source/v${MY_PV}/postgresql-${MY_PV}.tar.bz2"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

IUSE="debug doc +icu kerberos ldap llvm +lz4 nls pam perl python +readline
	selinux systemd ssl static-libs tcl test uuid xml zlib zstd"

REQUIRED_USE="
llvm? ( ${LLVM_REQUIRED_USE} )
python? ( ${PYTHON_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

CDEPEND="
>=app-eselect/eselect-postgresql-2.0
acct-group/postgres
acct-user/postgres
sys-apps/less
virtual/libintl
icu? ( dev-libs/icu:= )
kerberos? ( app-crypt/mit-krb5 )
ldap? ( net-nds/openldap:= )
llvm? ( $(llvm_gen_dep '
	sys-devel/clang:${LLVM_SLOT}
	sys-devel/llvm:${LLVM_SLOT}
	') )
lz4? ( app-arch/lz4 )
pam? ( sys-libs/pam )
perl? ( >=dev-lang/perl-5.14:= )
python? ( ${PYTHON_DEPS} )
readline? ( sys-libs/readline:0= )
ssl? ( >=dev-libs/openssl-0.9.6-r1:0= )
systemd? ( sys-apps/systemd )
tcl? ( >=dev-lang/tcl-8:0= )
xml? (
	dev-libs/libxml2
	dev-libs/libxslt
)
zlib? ( sys-libs/zlib )
zstd? ( app-arch/zstd )
"

# uuid flags -- depend on sys-apps/util-linux for Linux libcs, or if no
# supported libc in use depend on dev-libs/ossp-uuid. For BSD systems,
# the libc includes UUID functions.
UTIL_LINUX_LIBC=( elibc_{glibc,musl} )

nest_usedep() {
	local front back
	while [[ ${#} -gt 1 ]]; do
		front+="${1}? ( "
		back+=" )"
		shift
	done
	echo "${front}${1}${back}"
}

CDEPEND+="
uuid? (
	${UTIL_LINUX_LIBC[@]/%/? ( sys-apps/util-linux )}
	$(nest_usedep ${UTIL_LINUX_LIBC[@]/#/!} dev-libs/ossp-uuid)
)"

DEPEND="${CDEPEND}
>=dev-lang/perl-5.8
app-alternatives/lex
sys-devel/bison
nls? ( sys-devel/gettext )
xml? ( virtual/pkgconfig )
"

RDEPEND="${CDEPEND}
selinux? ( sec-policy/selinux-postgresql )
"

# Openjade, docbook, XML, and XSLT are needed to generate manpages and
# any documentation that may be elected.
BDEPEND="
app-text/openjade
app-text/docbook-dsssl-stylesheets
app-text/docbook-sgml-dtd:4.5
app-text/docbook-xml-dtd:4.5
app-text/docbook-xsl-stylesheets
dev-libs/libxml2
dev-libs/libxslt
test? (
	>=dev-lang/perl-5.14:=
	dev-perl/IPC-Run
	virtual/perl-Test-Simple
	virtual/perl-ExtUtils-MakeMaker
)
"

pkg_setup() {
	CONFIG_CHECK="~SYSVIPC" linux-info_pkg_setup

	use llvm && llvm-r1_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Set proper run directory
	sed "s|\(PGSOCKET_DIR\s\+\)\"/tmp\"|\1\"${EPREFIX}/run/postgresql\"|" \
		-i src/include/pg_config_manual.h || die

	# Rely on $PATH being in the proper order so that the correct
	# install program is used for modules utilizing PGXS in both
	# hardened and non-hardened environments. (Bug #528786)
	sed 's/@install_bin@/install -c/' -i src/Makefile.global.in || die

	if use pam ; then
		sed "s/\(#define PGSQL_PAM_SERVICE \"postgresql\)/\1-${SLOT}/" \
			-i src/backend/libpq/auth.c || \
			die 'PGSQL_PAM_SERVICE rename failed.'
	fi

	default
}

src_configure() {
	case ${CHOST} in
		*-darwin*|*-solaris*)
			use nls && append-libs intl
			;;
	esac
	export LDFLAGS_SL="${LDFLAGS}"
	export LDFLAGS_EX="${LDFLAGS}"

	local emesonargs=(
		--prefix="${EPREFIX}/usr/$(get_libdir)/postgresql-${SLOT}"
		--datadir="${EPREFIX}/usr/share/postgresql-${SLOT}"
		--includedir="${EPREFIX}/usr/include/postgresql-${SLOT}"
		--mandir="${EPREFIX}/usr/share/postgresql-${SLOT}/man"
		--sysconfdir="${EPREFIX}/etc/postgresql-${SLOT}"
		-Dsystem_tzdata="${EPREFIX}/usr/share/zoneinfo"
		$(meson_feature icu)
		$(meson_feature kerberos gssapi)
		$(meson_feature ldap)
		$(meson_feature llvm)
		$(meson_feature lz4)
		$(meson_feature nls)
		$(meson_feature pam)
		$(meson_feature perl plperl)
		$(meson_feature python plpython)
		$(meson_feature readline)
		$(meson_feature systemd)
		$(meson_feature tcl pltcl)
		$(meson_feature xml libxml)
		$(meson_feature xml libxslt)
		$(meson_feature zlib)
		$(meson_feature zstd)
		$(meson_use !alpha spinlocks)
	)

	use debug && emesonargs+=( "--debug" )
	use ssl && emesonargs+=( "-Dssl=openssl" )

	local i uuid_config=""
	if use uuid; then
		for i in ${UTIL_LINUX_LIBC[@]}; do
			use ${i} && uuid_config="-Duuid=e2fs"
		done

		emesonargs+=( ${uuid_config:-"-Duuid=ossp"} )
	fi

	meson_src_configure
}

src_compile() {
	meson_src_compile

	if use doc ; then
		# Generates both manpages and HTML documentation.
		meson_src_compile docs
	else
		meson_src_compile man
	fi
}

src_test() {
	if [[ ${UID} -ne 0 ]] ; then
		# Some ICU tests fail if LC_CTYPE and LC_COLLATE aren't the same. We set
		# LC_CTYPE to be equal to LC_COLLATE since LC_COLLATE is set by Portage.
		local old_ctype=${LC_CTYPE}
		export LC_CTYPE=${LC_COLLATE}
		meson_src_test
		export LC_CTYPE=${old_ctype}
	else
		ewarn 'Tests cannot be run as root. Enable "userpriv" in FEATURES.'
		ewarn 'Skipping.'
	fi
}

src_install() {
	meson_src_install

	sed -e "s|@SLOT@|${SLOT}|g" -e "s|@LIBDIR@|$(get_libdir)|g" \
		"${FILESDIR}/${PN}.confd-9.3" | newconfd - "${PN}-${SLOT}"

	sed -e "s|@SLOT@|${SLOT}|g" -e "s|@LIBDIR@|$(get_libdir)|g" \
		"${FILESDIR}/${PN}.init-9.3-r1" | newinitd - "${PN}-${SLOT}"

	insinto "/etc/postgresql-${SLOT}"
	newins src/bin/psql/psqlrc.sample psqlrc

	# Create slot specific links to their related executables, so that they're
	# always available. For example, pg_config9999 is always available whereas
	# the pg_config is controlled by postgresql.eselect.
	local f bn
	for f in $(find "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/bin" \
					-mindepth 1 -maxdepth 1)
	do
		bn=$(basename "${f}")
		dosym "../$(get_libdir)/postgresql-${SLOT}/bin/${bn}" \
			  "/usr/bin/${bn}${SLOT/.}"
	done

	# Create slot specific man pages so that they're always available. As above
	# for the executables, make `man pg_config9999` always refer to the same
	# manpage, whereas postgresql.eselect controls which manpage `man pg_config`
	# refers.  And, since postgresql.eselect controls the manpages, doman would
	# actually do the wrong thing for us, hence insinto and doins.
	insinto "/usr/share/postgresql-${SLOT}/man/"
	doins -r "${BUILD_DIR}"/doc/src/sgml/man{1,3,7}
	docompress /usr/share/postgresql-"${SLOT}"/man/man{1,3,7}

	local bn f mansec slotted_name
	for mansec in 1 3 7 ; do
		local rel_manpath="../../postgresql-${SLOT}/man/man${mansec}"

		mkdir -p "${ED}"/usr/share/man/man${mansec} || die "making man dir"
		pushd "${ED}"/usr/share/man/man${mansec} > /dev/null || die "pushd failed"

		for f in "${ED}/usr/share/postgresql-${SLOT}/man/man${mansec}"/* ; do
			bn=$(basename "${f}")
			slotted_name=${bn%."${mansec}"}${SLOT}.${mansec}
			case ${bn} in
				TABLE.7|WITH.7)
					echo ".so ${rel_manpath}/SELECT.7" > "${slotted_name}"
					;;
				*)
					echo ".so ${rel_manpath}/${bn}" > "${slotted_name}"
					;;
			esac
		done

		popd > /dev/null || die "popd failed"
	done

	# All of the use flag influenced installs/removals begin here.
	use doc && dodoc -r "${BUILD_DIR}"/doc/src/sgml/html

	use pam && pamd_mimic system-auth "${PN}-${SLOT}" auth account session

	if use prefix ; then
		keepdir /run/postgresql
		fperms 1775 /run/postgresql
	fi

	# Don't delete libpg{port,common}.a (Bug #571046). They're always
	# needed by extensions utilizing PGXS.
	use static-libs || \
		find "${ED}" -name '*.a' ! -name libpgport.a ! -name libpgcommon.a \
			 -delete

	if use systemd; then
		newbin "${FILESDIR}/${PN}-check-db-dir" "${PN}-${SLOT}-check-db-dir"

		sed -e "s|@SLOT@|${SLOT}|g" -e "s|@LIBDIR@|$(get_libdir)|g" \
			"${FILESDIR}/${PN}.service-9.6-r1" | \
			systemd_newunit - "${PN}-${SLOT}.service"
		newtmpfiles "${FILESDIR}/${PN}.tmpfiles" "${PN}-${SLOT}.conf"
	fi
}

pkg_postinst() {
	use systemd && tmpfiles_process "${PN}-${SLOT}.conf"

	# See comment in pkg_postrm().
	[[ ${SLOT} = $(postgresql-config show) ]] && postgresql-config update

	elog "Gentoo specific documentation:"
	elog "https://wiki.gentoo.org/wiki/PostgreSQL"
	elog
	elog "Official documentation:"
	if use doc ; then
		elog "${EROOT}/usr/share/doc/${PF}/html"
	else
		elog "https://www.postgresql.org/docs/${SLOT/9999*/devel}/index.html"
	fi
	elog

	elog "You can find release notes at:"
	if use doc ; then
		elog "${EROOT}/usr/share/doc/${PF}/html/release.html"
	else
		elog "https://www.postgresql.org/docs/${SLOT/9999*/devel}/release.html"
	fi
	elog

	elog "If you need a global psqlrc-file, you can place it in:"
	elog "    ${EROOT}/etc/postgresql-${SLOT}/"
	elog
	elog "The next two items only apply when running a server on this machine."
	elog "------------------------------------------------------------------------"
	elog "1. You may want to edit PG_INITDB_OPTS in the following file so that it"
	elog "   contains your preferred locale, and other options, before"
	elog "   initializing the cluster:"
	elog "    ${EROOT}/etc/conf.d/postgresql-${SLOT}"
	elog
	elog "2. Then, run the following command to initialize database cluster:"
	elog "    emerge --config =${CATEGORY}/${PN}:${SLOT}"
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		ewarn "Were you running PostgreSQL ${SLOT} as a server? If no, ignore the rest"
		ewarn "of this warning."
		ewarn
		ewarn "Have you dumped and/or migrated the ${SLOT} database cluster?"
		ewarn "\thttps://wiki.gentoo.org/wiki/PostgreSQL/QuickStart#Migrating_PostgreSQL"

		ebegin "Resuming removal in 10 seconds (Control-C to cancel)"
		sleep 10
		eend 0
	fi
}

pkg_postrm() {
	# The links managed by eselect are unversioned only, and would only be
	# impacted if the selected slot and ebuild slot are the same. For example,
	# if the selected slot is SLOT+1, then nothing that happened with this
	# ebuild will impact the unversioned links.
	[[ ${SLOT} = $(postgresql-config show) ]] && postgresql-config update
}

pkg_config() {
	[[ -f "${EROOT}/etc/conf.d/postgresql-${SLOT}" ]] \
		&& source "${EROOT}/etc/conf.d/postgresql-${SLOT}"
	[[ -z "${PGDATA}" ]] && PGDATA="${EROOT}/etc/postgresql-${SLOT}/"
	[[ -z "${DATA_DIR}" ]] \
		&& DATA_DIR="${EROOT}/var/lib/postgresql/${SLOT}/data"

	# environment.bz2 may not contain the same locale as the current system
	# locale. Unset and source from the current system locale.
	if [ -f "${EROOT}/etc/env.d/02locale" ]; then
		unset LANG
		unset LC_CTYPE
		unset LC_NUMERIC
		unset LC_TIME
		unset LC_COLLATE
		unset LC_MONETARY
		unset LC_MESSAGES
		unset LC_ALL
		source "${EROOT}/etc/env.d/02locale"
		[ -n "${LANG}" ] && export LANG
		[ -n "${LC_CTYPE}" ] && export LC_CTYPE
		[ -n "${LC_NUMERIC}" ] && export LC_NUMERIC
		[ -n "${LC_TIME}" ] && export LC_TIME
		[ -n "${LC_COLLATE}" ] && export LC_COLLATE
		[ -n "${LC_MONETARY}" ] && export LC_MONETARY
		[ -n "${LC_MESSAGES}" ] && export LC_MESSAGES
		[ -n "${LC_ALL}" ] && export LC_ALL
	fi

	einfo "You can modify the paths and options passed to initdb by editing:"
	einfo "    ${EROOT}/etc/conf.d/postgresql-${SLOT}"
	einfo
	einfo "Information on options that can be passed to initdb are found at:"
	einfo "    https://www.postgresql.org/docs/${SLOT}/static/creating-cluster.html"
	einfo "    https://www.postgresql.org/docs/${SLOT}/static/app-initdb.html"
	einfo
	einfo "PG_INITDB_OPTS is currently set to:"
	if [[ -z "${PG_INITDB_OPTS}" ]] ; then
		einfo "    (none)"
	else
		einfo "    ${PG_INITDB_OPTS}"
	fi
	einfo
	einfo "Configuration files will be installed to:"
	einfo "    ${PGDATA}"
	einfo
	einfo "The database cluster will be created in:"
	einfo "    ${DATA_DIR}"
	einfo

	ebegin "Continuing initialization in 5 seconds (Control-C to cancel)"
	sleep 5
	eend 0

	if [[ -n "$(ls -A ${DATA_DIR} 2> /dev/null)" ]] ; then
		eerror "The given directory, '${DATA_DIR}', is not empty."
		eerror "Modify DATA_DIR to point to an empty directory."
		die "${DATA_DIR} is not empty."
	fi

	einfo "Creating the data directory ..."
	if [[ ${EUID} == 0 ]] ; then
		mkdir -p "$(dirname ${DATA_DIR%/})" || die "Couldn't parent dirs"
		mkdir -m 0700 "${DATA_DIR%/}" || die "Couldn't make DATA_DIR"
		chown -h postgres:postgres "${DATA_DIR%/}" || die "Couldn't chown"
	fi

	einfo "Initializing the database ..."

	if [[ ${EUID} == 0 ]] ; then
		su - postgres -c "${EROOT}/usr/$(get_libdir)/postgresql-${SLOT}/bin/initdb -D \"${DATA_DIR}\" ${PG_INITDB_OPTS}"
	else
		"${EROOT}"/usr/$(get_libdir)/postgresql-${SLOT}/bin/initdb -U postgres -D "${DATA_DIR}" ${PG_INITDB_OPTS}
	fi

	if [[ "${DATA_DIR%/}" != "${PGDATA%/}" ]] ; then
		mv "${DATA_DIR%/}"/{pg_{hba,ident},postgresql}.conf "${PGDATA}"
		ln -s "${PGDATA%/}"/{pg_{hba,ident},postgresql}.conf "${DATA_DIR%/}"
	fi

	# unix_socket_directory has no effect in postgresql.conf as it's
	# overridden in the initscript
	sed '/^#unix_socket_directories/,+1d' -i "${PGDATA%/}"/postgresql.conf

	einfo "The autovacuum function, which was in contrib, has been moved to the main"
	einfo "PostgreSQL functions starting with 8.1, and starting with 8.4 is now enabled"
	einfo "by default. You can disable it in the cluster's:"
	einfo "    ${PGDATA%/}/postgresql.conf"
	einfo
	if ! use systemd; then
		einfo "The PostgreSQL server, by default, will log events to:"
		einfo "    ${DATA_DIR%/}/postmaster.log"
		einfo
	fi
	if use prefix ; then
		einfo "The location of the configuration files have moved to:"
		einfo "    ${PGDATA}"
		einfo "To start the server:"
		einfo "    pg_ctl start -D ${DATA_DIR} -o '-D ${PGDATA} --data-directory=${DATA_DIR}'"
		einfo "To stop:"
		einfo "    pg_ctl stop -D ${DATA_DIR}"
		einfo
		einfo "Or move the configuration files back:"
		einfo "mv ${PGDATA}*.conf ${DATA_DIR}"
	elif use systemd; then
		einfo "You should use the 'postgresql-${SLOT}.service' unit to run PostgreSQL"
		einfo "instead of 'pg_ctl'."
	else
		einfo "You should use the '${EROOT}/etc/init.d/postgresql-${SLOT}' script to run PostgreSQL"
		einfo "instead of 'pg_ctl'."
	fi
}
