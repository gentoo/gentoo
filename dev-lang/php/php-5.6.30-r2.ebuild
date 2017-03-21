# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic versionator systemd

DESCRIPTION="The PHP language runtime engine"
HOMEPAGE="http://php.net/"
SRC_URI="http://php.net/distributions/${P}.tar.xz"

LICENSE="PHP-3.01
	BSD
	Zend-2.0
	bcmath? ( LGPL-2.1+ )
	fpm? ( BSD-2 )
	gd? ( gd )
	unicode? ( BSD-2 LGPL-2.1 )"

SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

# We can build the following SAPIs in the given order
SAPIS="embed cli cgi fpm apache2"

# SAPIs and SAPI-specific USE flags (cli SAPI is default on):
IUSE="${IUSE}
	${SAPIS/cli/+cli}
	threads"

IUSE="${IUSE} acl bcmath berkdb bzip2 calendar cdb cjk
	coverage crypt +ctype curl debug
	enchant exif +fileinfo +filter firebird
	flatfile ftp gd gdbm gmp +hash +iconv imap inifile
	intl iodbc ipv6 +json kerberos ldap ldap-sasl libedit libressl
	mhash mssql mysql libmysqlclient mysqli nls
	oci8-instant-client odbc +opcache pcntl pdo +phar +posix postgres qdbm
	readline recode selinux +session sharedmem
	+simplexml snmp soap sockets spell sqlite ssl
	sybase-ct sysvipc systemd tidy +tokenizer truetype unicode vpx wddx
	+xml xmlreader xmlwriter xmlrpc xpm xslt zip zlib"

# The supported (that is, autodetected) versions of BDB are listed in
# the ./configure script. Other versions *work*, but we need to stick to
# the ones that can be detected to avoid a repeat of bug #564824.
COMMON_DEPEND="
	>=app-eselect/eselect-php-0.9.1[apache2?,fpm?]
	>=dev-libs/libpcre-8.32[unicode]
	acl? ( sys-apps/acl )
	apache2? ( || ( >=www-servers/apache-2.4[apache2_modules_unixd,threads=]
		<www-servers/apache-2.4[threads=] ) )
	berkdb? ( || ( 	sys-libs/db:5.3
					sys-libs/db:5.1
					sys-libs/db:4.8
					sys-libs/db:4.7
					sys-libs/db:4.6
					sys-libs/db:4.5 ) )
	bzip2? ( app-arch/bzip2 )
	cdb? ( || ( dev-db/cdb dev-db/tinycdb ) )
	cjk? ( !gd? (
		virtual/jpeg:0
		media-libs/libpng:0=
		sys-libs/zlib
	) )
	coverage? ( dev-util/lcov )
	crypt? ( >=dev-libs/libmcrypt-2.4 )
	curl? ( >=net-misc/curl-7.10.5 )
	enchant? ( app-text/enchant )
	exif? ( !gd? (
		virtual/jpeg:0
		media-libs/libpng:0=
		sys-libs/zlib
	) )
	firebird? ( dev-db/firebird )
	gd? ( virtual/jpeg:0 media-libs/libpng:0= sys-libs/zlib )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	gmp? ( dev-libs/gmp:0 )
	iconv? ( virtual/libiconv )
	imap? ( virtual/imap-c-client[kerberos=,ssl=] )
	intl? ( dev-libs/icu:= )
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-1.2.11 )
	ldap-sasl? ( dev-libs/cyrus-sasl >=net-nds/openldap-1.2.11 )
	libedit? ( || ( sys-freebsd/freebsd-lib dev-libs/libedit ) )
	mssql? ( dev-db/freetds[mssql] )
	libmysqlclient? (
		mysql? ( virtual/libmysqlclient:= )
		mysqli? ( virtual/libmysqlclient:= )
	)
	nls? ( sys-devel/gettext )
	oci8-instant-client? ( dev-db/oracle-instantclient-basic )
	odbc? ( >=dev-db/unixODBC-1.8.13 )
	postgres? ( dev-db/postgresql:* )
	qdbm? ( dev-db/qdbm )
	readline? ( sys-libs/readline:0= )
	recode? ( app-text/recode )
	sharedmem? ( dev-libs/mm )
	simplexml? ( >=dev-libs/libxml2-2.6.8 )
	snmp? ( >=net-analyzer/net-snmp-5.2 )
	soap? ( >=dev-libs/libxml2-2.6.8 )
	spell? ( >=app-text/aspell-0.50 )
	sqlite? ( >=dev-db/sqlite-3.7.6.3 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl )
	)
	sybase-ct? ( dev-db/freetds )
	tidy? ( app-text/htmltidy )
	truetype? (
		=media-libs/freetype-2*
		>=media-libs/t1lib-5.0.0
		!gd? (
			virtual/jpeg:0 media-libs/libpng:0= sys-libs/zlib )
	)
	unicode? ( dev-libs/oniguruma )
	vpx? ( media-libs/libvpx )
	wddx? ( >=dev-libs/libxml2-2.6.8 )
	xml? ( >=dev-libs/libxml2-2.6.8 )
	xmlrpc? ( >=dev-libs/libxml2-2.6.8 virtual/libiconv )
	xmlreader? ( >=dev-libs/libxml2-2.6.8 )
	xmlwriter? ( >=dev-libs/libxml2-2.6.8 )
	xpm? (
		x11-libs/libXpm
		virtual/jpeg:0
		media-libs/libpng:0= sys-libs/zlib
	)
	xslt? ( dev-libs/libxslt >=dev-libs/libxml2-2.6.8 )
	zip? ( sys-libs/zlib )
	zlib? ( sys-libs/zlib )
"

RDEPEND="${COMMON_DEPEND}
	virtual/mta
	fpm? (
		selinux? ( sec-policy/selinux-phpfpm )
		systemd? ( sys-apps/systemd ) )"

DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	>=sys-devel/bison-3.0.1
	sys-devel/flex
	>=sys-devel/m4-1.4.3
	>=sys-devel/libtool-1.5.18"

# Without USE=readline or libedit, the interactive "php -a" CLI will hang.
REQUIRED_USE="
	cli? ( ^^ ( readline libedit ) )
	truetype? ( gd )
	vpx? ( gd )
	cjk? ( gd )
	exif? ( gd )

	xpm? ( gd )
	gd? ( zlib )
	simplexml? ( xml )
	soap? ( xml )
	wddx? ( xml )
	xmlrpc? ( || ( xml iconv ) )
	xmlreader? ( xml )
	xslt? ( xml )
	ldap-sasl? ( ldap )
	mhash? ( hash )
	phar? ( hash )
	libmysqlclient? ( || (
		mysql
		mysqli
		pdo
	) )

	qdbm? ( !gdbm )
	readline? ( !libedit )
	recode? ( !imap !mysql !mysqli )
	sharedmem? ( !threads )

	!cli? ( !cgi? ( !fpm? ( !apache2? ( !embed? ( cli ) ) ) ) )"

PHP_MV="$(get_major_version)"

php_install_ini() {
	local phpsapi="${1}"

	# work out where we are installing the ini file
	php_set_ini_dir "${phpsapi}"

	# Always install the production INI file, bug 611214.
	local phpinisrc="php.ini-production-${phpsapi}"
	cp php.ini-production "${phpinisrc}" || die

	# default to /tmp for save_path, bug #282768
	sed -e 's|^;session.save_path .*$|session.save_path = "'"${EPREFIX}"'/tmp"|g' -i "${phpinisrc}" || die

	# Set the extension dir
	sed -e "s|^extension_dir .*$|extension_dir = ${extension_dir}|g" \
		-i "${phpinisrc}" || die

	# Set the include path to point to where we want to find PEAR packages
	sed -e 's|^;include_path = ".:/php/includes".*|include_path = ".:'"${EPREFIX}"'/usr/share/php'${PHP_MV}':'"${EPREFIX}"'/usr/share/php"|' -i "${phpinisrc}" || die

	dodir "${PHP_INI_DIR#${EPREFIX}}"
	insinto "${PHP_INI_DIR#${EPREFIX}}"
	newins "${phpinisrc}" php.ini

	elog "Installing php.ini for ${phpsapi} into ${PHP_INI_DIR#${EPREFIX}}"
	elog

	dodir "${PHP_EXT_INI_DIR#${EPREFIX}}"
	dodir "${PHP_EXT_INI_DIR_ACTIVE#${EPREFIX}}"

	if use opcache; then
		elog "Adding opcache to $PHP_EXT_INI_DIR"
		echo "zend_extension=${PHP_DESTDIR}/$(get_libdir)/opcache.so" >> \
			 "${D}/${PHP_EXT_INI_DIR}"/opcache.ini
		dosym "${PHP_EXT_INI_DIR#${EPREFIX}}/opcache.ini" \
			  "${PHP_EXT_INI_DIR_ACTIVE#${EPREFIX}}/opcache.ini"
	fi

	# SAPI-specific handling
	if [[ "${sapi}" == "fpm" ]] ; then
		einfo "Installing FPM config file php-fpm.conf"
		insinto "${PHP_INI_DIR#${EPREFIX}}"
		doins sapi/fpm/php-fpm.conf
	fi

	dodoc php.ini-{development,production}
}

php_set_ini_dir() {
	PHP_INI_DIR="${EPREFIX}/etc/php/${1}-php${SLOT}"
	PHP_EXT_INI_DIR="${PHP_INI_DIR}/ext"
	PHP_EXT_INI_DIR_ACTIVE="${PHP_INI_DIR}/ext-active"
}

src_prepare() {
	eapply "${FILESDIR}/php-${SLOT}-no-bison-warnings.patch"

	# Change PHP branding
	# Get the alpha/beta/rc version
	sed -re	"s|^(PHP_EXTRA_VERSION=\").*(\")|\1-pl${PR/r/}-gentoo\2|g" \
		-i configure.in || die "Unable to change PHP branding"

	# Patch PHP to show Gentoo as the server platform
	sed -e 's/PHP_UNAME=`uname -a | xargs`/PHP_UNAME=`uname -s -n -r -v | xargs`/g' \
		-i configure.in || die "Failed to fix server platform name"

	# Prevent PHP from activating the Apache config,
	# as we will do that ourselves
	sed -i \
		-e "s,-i -a -n php${PHP_MV},-i -n php${PHP_MV},g" \
		-e "s,-i -A -n php${PHP_MV},-i -n php${PHP_MV},g" \
		configure sapi/apache2filter/config.m4 sapi/apache2handler/config.m4 \
		|| die

	# Patch PHP to support heimdal instead of mit-krb5
	if has_version "app-crypt/heimdal" ; then
		sed -e 's|gssapi_krb5|gssapi|g' -i acinclude.m4 \
			|| die "Failed to fix heimdal libname"
		sed -e 's|PHP_ADD_LIBRARY(k5crypto, 1, $1)||g' -i acinclude.m4 \
			|| die "Failed to fix heimdal crypt library reference"
	fi

	eapply_user

	# Force rebuilding aclocal.m4
	rm -f aclocal.m4 || die "failed to remove aclocal.m4 in src_prepare"
	eautoreconf

	if [[ ${CHOST} == *-darwin* ]] ; then
		# http://bugs.php.net/bug.php?id=48795, bug #343481
		sed -i -e '/BUILD_CGI="\\$(CC)/s/CC/CXX/' configure || die
	fi
}

src_configure() {
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/mib_indexes

	PHP_DESTDIR="${EPREFIX}/usr/$(get_libdir)/php${SLOT}"

	# The php-fpm config file wants localstatedir to be ${EPREFIX}/var
	# and not the Gentoo default ${EPREFIX}/var/lib. See bug 572002.
	local our_conf=(
		--prefix="${PHP_DESTDIR}"
		--mandir="${PHP_DESTDIR}/man"
		--infodir="${PHP_DESTDIR}/info"
		--libdir="${PHP_DESTDIR}/lib"
		--with-libdir="$(get_libdir)"
		--localstatedir="${EPREFIX}/var"
		--without-pear
		$(use_enable threads maintainer-zts)
	)

	our_conf+=(
		$(use_with acl fpm-acl)
		$(use_enable bcmath bcmath)
		$(use_with bzip2 bz2 "${EPREFIX}/usr")
		$(use_enable calendar calendar)
		$(use_enable coverage gcov)
		$(use_enable ctype ctype)
		$(use_with curl curl "${EPREFIX}/usr")
		$(use_enable xml dom)
		$(use_with enchant enchant "${EPREFIX}/usr")
		$(use_enable exif exif)
		$(use_enable fileinfo fileinfo)
		$(use_enable filter filter)
		$(use_enable ftp ftp)
		$(use_with nls gettext "${EPREFIX}/usr")
		$(use_with gmp gmp "${EPREFIX}/usr")
		$(use_enable hash hash)
		$(use_with mhash mhash "${EPREFIX}/usr")
		$(use_with iconv iconv \
			$(use elibc_glibc || use elibc_musl || echo "${EPREFIX}/usr"))
		$(use_enable intl intl)
		$(use_enable ipv6 ipv6)
		$(use_enable json json)
		$(use_with kerberos kerberos "${EPREFIX}/usr")
		$(use_enable xml libxml)
		$(use_with xml libxml-dir "${EPREFIX}/usr")
		$(use_enable unicode mbstring)
		$(use_with crypt mcrypt "${EPREFIX}/usr")
		$(use_with mssql mssql "${EPREFIX}/usr")
		$(use_with unicode onig "${EPREFIX}/usr")
		$(use_with ssl openssl "${EPREFIX}/usr")
		$(use_with ssl openssl-dir "${EPREFIX}/usr")
		$(use_enable pcntl pcntl)
		$(use_enable phar phar)
		$(use_enable pdo pdo)
		$(use_enable opcache opcache)
		$(use_with postgres pgsql "${EPREFIX}/usr")
		$(use_enable posix posix)
		$(use_with spell pspell "${EPREFIX}/usr")
		$(use_with recode recode "${EPREFIX}/usr")
		$(use_enable simplexml simplexml)
		$(use_enable sharedmem shmop)
		$(use_with snmp snmp "${EPREFIX}/usr")
		$(use_enable soap soap)
		$(use_enable sockets sockets)
		$(use_with sqlite sqlite3 "${EPREFIX}/usr")
		$(use_with sybase-ct sybase-ct "${EPREFIX}/usr")
		$(use_enable sysvipc sysvmsg)
		$(use_enable sysvipc sysvsem)
		$(use_enable sysvipc sysvshm)
		$(use_with systemd fpm-systemd)
		$(use_with tidy tidy "${EPREFIX}/usr")
		$(use_enable tokenizer tokenizer)
		$(use_enable wddx wddx)
		$(use_enable xml xml)
		$(use_enable xmlreader xmlreader)
		$(use_enable xmlwriter xmlwriter)
		$(use_with xmlrpc xmlrpc)
		$(use_with xslt xsl "${EPREFIX}/usr")
		$(use_enable zip zip)
		$(use_with zlib zlib "${EPREFIX}/usr")
		$(use_enable debug debug)
	)

	# DBA support
	if use cdb || use berkdb || use flatfile || use gdbm || use inifile \
		|| use qdbm ; then
		our_conf+=( "--enable-dba${shared}" )
	fi

	# DBA drivers support
	our_conf+=(
		$(use_with cdb cdb)
		$(use_with berkdb db4 "${EPREFIX}/usr")
		$(use_enable flatfile flatfile)
		$(use_with gdbm gdbm "${EPREFIX}/usr")
		$(use_enable inifile inifile)
		$(use_with qdbm qdbm "${EPREFIX}/usr")
	)

	# Support for the GD graphics library
	our_conf+=(
		$(use_with truetype freetype-dir "${EPREFIX}/usr")
		$(use_with truetype t1lib "${EPREFIX}/usr")
		$(use_enable cjk gd-jis-conv)
		$(use_with gd jpeg-dir "${EPREFIX}/usr")
		$(use_with gd png-dir "${EPREFIX}/usr")
		$(use_with xpm xpm-dir "${EPREFIX}/usr")
		$(use_with vpx vpx-dir "${EPREFIX}/usr")
	)
	# enable gd last, so configure can pick up the previous settings
	our_conf+=( $(use_with gd gd) )

	# IMAP support
	if use imap ; then
		our_conf+=(
			$(use_with imap imap "${EPREFIX}/usr")
			$(use_with ssl imap-ssl "${EPREFIX}/usr")
		)
	fi

	# Interbase/firebird support
	our_conf+=( $(use_with firebird interbase "${EPREFIX}/usr") )

	# LDAP support
	if use ldap ; then
		our_conf+=(
			$(use_with ldap ldap "${EPREFIX}/usr")
			$(use_with ldap-sasl ldap-sasl "${EPREFIX}/usr")
		)
	fi

	# MySQL support
	local mysqllib="mysqlnd"
	local mysqlilib="mysqlnd"
	use libmysqlclient && mysqllib="${EPREFIX}/usr"
	use libmysqlclient && mysqlilib="${EPREFIX}/usr/bin/mysql_config"

	our_conf+=( $(use_with mysql mysql "${mysqllib}") )
	our_conf+=( $(use_with mysqli mysqli "${mysqlilib}") )

	local mysqlsock="${EPREFIX}/var/run/mysqld/mysqld.sock"
	if use mysql || use mysqli ; then
		our_conf+=( $(use_with mysql mysql-sock "${mysqlsock}") )
	fi

	# ODBC support
	our_conf+=(
		$(use_with odbc unixODBC "${EPREFIX}/usr")
		$(use_with iodbc iodbc "${EPREFIX}/usr")
	)

	# Oracle support
	our_conf+=( $(use_with oci8-instant-client oci8) )

	# PDO support
	if use pdo ; then
		our_conf+=(
			$(use_with mssql pdo-dblib)
			$(use_with mysql pdo-mysql "${mysqllib}")
			$(use_with postgres pdo-pgsql)
			$(use_with sqlite pdo-sqlite "${EPREFIX}/usr")
			$(use_with firebird pdo-firebird "${EPREFIX}/usr")
			$(use_with odbc pdo-odbc "unixODBC,${EPREFIX}/usr")
			$(use_with oci8-instant-client pdo-oci)
		)
	fi

	# readline/libedit support
	our_conf+=(
		$(use_with readline readline "${EPREFIX}/usr")
		$(use_with libedit libedit "${EPREFIX}/usr")
	)

	# Session support
	if use session ; then
		our_conf+=( $(use_with sharedmem mm "${EPREFIX}/usr") )
	else
		our_conf+=( $(use_enable session session) )
	fi

	# Use pic for shared modules such as apache2's mod_php
	our_conf+=( --with-pic )

	# we use the system copy of pcre
	# --with-pcre-regex affects ext/pcre
	# --with-pcre-dir affects ext/filter and ext/zip
	our_conf+=(
		--with-pcre-regex="${EPREFIX}/usr"
		--with-pcre-dir="${EPREFIX}/usr"
	)

	# Catch CFLAGS problems
	# Fixes bug #14067.
	# Changed order to run it in reverse for bug #32022 and #12021.
	replace-cpu-flags "k6*" "i586"

	# Cache the ./configure test results between SAPIs.
	our_conf+=( --cache-file="${T}/config.cache" )

	# Support user-passed configuration parameters
	our_conf+=( ${EXTRA_ECONF:-} )

	# Support the Apache2 extras, they must be set globally for all
	# SAPIs to work correctly, especially for external PHP extensions

	mkdir -p "${WORKDIR}/sapis-build" || die
	for one_sapi in $SAPIS ; do
		use "${one_sapi}" || continue
		php_set_ini_dir "${one_sapi}"

		# The BUILD_DIR variable is used to determine where to output
		# the files that autotools creates. This was all originally
		# based on the autotools-utils eclass.
		BUILD_DIR="${WORKDIR}/sapis-build/${one_sapi}"
		cp -a "${S}" "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" || die

		local sapi_conf=(
			--with-config-file-path="${PHP_INI_DIR}"
			--with-config-file-scan-dir="${PHP_EXT_INI_DIR_ACTIVE}"
		)

		for sapi in $SAPIS ; do
			case "$sapi" in
				cli|cgi|embed|fpm)
					if [[ "${one_sapi}" == "${sapi}" ]] ; then
						sapi_conf+=( "--enable-${sapi}" )
					else
						sapi_conf+=( "--disable-${sapi}" )
					fi
					;;

				apache2)
					if [[ "${one_sapi}" == "${sapi}" ]] ; then
						sapi_conf+=( --with-apxs2="${EPREFIX}/usr/bin/apxs" )
					else
						sapi_conf+=( --without-apxs2 )
					fi
					;;
			esac
		done

		# Construct the $myeconfargs array by concatenating $our_conf
		# (the common args) and $sapi_conf (the SAPI-specific args).
		local myeconfargs=( "${our_conf[@]}" )
		myeconfargs+=( "${sapi_conf[@]}" )

		pushd "${BUILD_DIR}" > /dev/null || die
		econf "${myeconfargs[@]}"
		popd > /dev/null || die
	done
}

src_compile() {
	# snmp seems to run during src_compile, too (bug #324739)
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/mib_indexes

	for sapi in ${SAPIS} ; do
		if use "${sapi}"; then
			cd "${WORKDIR}/sapis-build/$sapi" || \
				die "Failed to change dir to ${WORKDIR}/sapis-build/$1"
			emake
		fi
	done
}

src_install() {
	# see bug #324739 for what happens when we don't have that
	addpredict /usr/share/snmp/mibs/.index

	# grab the first SAPI that got built and install common files from there
	local first_sapi=""
	for sapi in $SAPIS ; do
		if use $sapi ; then
			first_sapi=$sapi
			break
		fi
	done

	# Makefile forgets to create this before trying to write to it...
	dodir "${PHP_DESTDIR#${EPREFIX}}/bin"

	# Install php environment (without any sapis)
	cd "${WORKDIR}/sapis-build/$first_sapi" || die
	emake INSTALL_ROOT="${D}" \
		install-build install-headers install-programs

	local extension_dir="$("${ED}/${PHP_DESTDIR#${EPREFIX}}/bin/php-config" --extension-dir)"

	# Create the directory where we'll put version-specific php scripts
	keepdir "/usr/share/php${PHP_MV}"

	local sapi="", file=""
	local sapi_list=""

	for sapi in ${SAPIS}; do
		if use "${sapi}" ; then
			einfo "Installing SAPI: ${sapi}"
			cd "${WORKDIR}/sapis-build/${sapi}" || die

			if [[ "${sapi}" == "apache2" ]] ; then
				# We're specifically not using emake install-sapi as libtool
				# may cause unnecessary relink failures (see bug #351266)
				insinto "${PHP_DESTDIR#${EPREFIX}}/apache2/"
				newins ".libs/libphp5$(get_libname)" \
					   "libphp${PHP_MV}$(get_libname)"
				keepdir "/usr/$(get_libdir)/apache2/modules"
			else
				# needed each time, php_install_ini would reset it
				local dest="${PHP_DESTDIR#${EPREFIX}}"
				into "${dest}"
				case "$sapi" in
					cli)
						source="sapi/cli/php"
						;;
					cgi)
						source="sapi/cgi/php-cgi"
						;;
					fpm)
						source="sapi/fpm/php-fpm"
						;;
					embed)
						source="libs/libphp${PHP_MV}$(get_libname)"
						;;
					*)
						die "unhandled sapi in src_install"
						;;
				esac

				if [[ "${source}" == *"$(get_libname)" ]]; then
					dolib.so "${source}"
				else
					dobin "${source}"
					local name="$(basename ${source})"
					dosym "${dest}/bin/${name}" "/usr/bin/${name}${SLOT}"
				fi
			fi

			php_install_ini "${sapi}"

			# construct correct SAPI string for php-config
			# thanks to ferringb for the bash voodoo
			if [[ "${sapi}" == "apache2" ]]; then
				sapi_list="${sapi_list:+${sapi_list} }apache2handler"
			else
				sapi_list="${sapi_list:+${sapi_list} }${sapi}"
			fi
		fi
	done

	# Installing opcache module
	if use opcache ; then
		into "${PHP_DESTDIR#${EPREFIX}}"
		dolib.so "modules/opcache$(get_libname)"
	fi

	# Install env.d files
	newenvd "${FILESDIR}/20php5-envd" "20php${SLOT}"
	sed -e "s|/lib/|/$(get_libdir)/|g" -i "${ED}/etc/env.d/20php${SLOT}" || die
	sed -e "s|php5|php${SLOT}|g" -i "${ED}/etc/env.d/20php${SLOT}" || die

	# set php-config variable correctly (bug #278439)
	sed -e "s:^\(php_sapis=\)\".*\"$:\1\"${sapi_list}\":" -i \
		"${ED}/usr/$(get_libdir)/php${SLOT}/bin/php-config" || die

	if use fpm ; then
		if use systemd; then
			systemd_newunit "${FILESDIR}/php-fpm_at.service" \
							"php-fpm@${SLOT}.service"
		else
			systemd_newunit "${FILESDIR}/php-fpm_at-simple.service" \
							"php-fpm@${SLOT}.service"
		fi
	fi
}

src_test() {
	echo ">>> Test phase [test]: ${CATEGORY}/${PF}"
	PHP_BIN="${WORKDIR}/sapis-build/cli/sapi/cli/php"
	if [[ ! -x "${PHP_BIN}" ]] ; then
		ewarn "Test phase requires USE=cli, skipping"
		return
	else
		export TEST_PHP_EXECUTABLE="${PHP_BIN}"
	fi

	if [[ -x "${WORKDIR}/sapis/cgi/php-cgi" ]] ; then
		export TEST_PHP_CGI_EXECUTABLE="${WORKDIR}/sapis/cgi/php-cgi"
	fi

	REPORT_EXIT_STATUS=1 "${TEST_PHP_EXECUTABLE}" -n  -d \
					  "session.save_path=${T}" \
					  "${WORKDIR}/sapis-build/cli/run-tests.php" -n -q -d \
					  "session.save_path=${T}"

	for name in ${EXPECTED_TEST_FAILURES}; do
		mv "${name}.out" "${name}.out.orig" 2>/dev/null || die
	done

	local failed="$(find -name '*.out')"
	if [[ ${failed} != "" ]] ; then
		ewarn "The following test cases failed unexpectedly:"
		for name in ${failed}; do
			ewarn "  ${name/.out/}"
		done
	else
		einfo "No unexpected test failures, all fine"
	fi

	if [[ ${PHP_SHOW_UNEXPECTED_TEST_PASS} == "1" ]] ; then
		local passed=""
		for name in ${EXPECTED_TEST_FAILURES}; do
			[[ -f "${name}.diff" ]] && continue
			passed="${passed} ${name}"
		done
		if [[ ${passed} != "" ]] ; then
			einfo "The following test cases passed unexpectedly:"
			for name in ${passed}; do
				ewarn "  ${passed}"
			done
		else
			einfo "None of the known-to-fail tests passed, all fine"
		fi
	fi
}

pkg_postinst() {
	# Output some general info to the user
	if use apache2 ; then
		elog
		elog "To enable PHP in apache, you will need to add \"-D PHP\" to"
		elog "your apache2 command. OpenRC users can append that string to"
		elog "APACHE2_OPTS in /etc/conf.d/apache2."
		elog
		elog "The apache module configuration file 70_mod_php.conf is"
		elog "provided (and maintained) by eselect-php."
		elog
	fi

	# Create the symlinks for php
	for m in ${SAPIS}; do
		[[ ${m} == 'embed' ]] && continue;
		if use $m ; then
			local ci=$(eselect php show $m)
			if [[ -z $ci ]]; then
				eselect php set $m php${SLOT} || die
				einfo "Switched ${m} to use php:${SLOT}"
				einfo
			elif [[ $ci != "php${SLOT}" ]] ; then
				elog "To switch $m to use php:${SLOT}, run"
				elog "    eselect php set $m php${SLOT}"
				elog
			fi
		fi
	done

	# Remove dead symlinks for SAPIs that were just disabled. For
	# example, if the user has the cgi SAPI enabled, then he has an
	# eselect-php symlink for it. If he later reinstalls PHP with
	# USE="-cgi", that symlink will break. This call to eselect is
	# supposed to remove that dead link per bug 572436.
	eselect php cleanup || die

	if ! has "php${SLOT/./-}" ${PHP_TARGETS}; then
	   elog "To build extensions for this version of PHP, you will need to"
	   elog "add php${SLOT/./-} to your PHP_TARGETS USE_EXPAND variable."
	   elog
	fi

	# Warn about the removal of PHP_INI_VERSION if the user has it set.
	if [[ -n "${PHP_INI_VERSION}" ]]; then
		ewarn 'The PHP_INI_VERSION variable has been phased out. You may'
		ewarn 'remove it from your configuration at your convenience. See'
		ewarn
		ewarn '  https://bugs.gentoo.org/611214'
		ewarn
		ewarn 'for more information.'
	fi

	elog "For details on how version slotting works, please see"
	elog "the wiki:"
	elog
	elog "  https://wiki.gentoo.org/wiki/PHP"
	elog
}

pkg_postrm() {
	# This serves two purposes. First, if we have just removed the last
	# installed version of PHP, then this will remove any dead symlinks
	# belonging to eselect-php. Second, if a user upgrades slots from
	# (say) 5.6 to 7.0 and depcleans the old slot, then this will update
	# his existing symlinks to point to the new 7.0 installation. The
	# latter is bug 432962.
	#
	# Note: the eselect-php package may not be installed at this point,
	# so we can't die() if this command fails.
	eselect php cleanup
}
