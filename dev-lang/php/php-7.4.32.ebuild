# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

WANT_AUTOMAKE="none"

inherit flag-o-matic systemd autotools

MY_PV=${PV/_rc/RC}
DESCRIPTION="The PHP language runtime engine"
HOMEPAGE="https://www.php.net/"
SRC_URI="https://www.php.net/distributions/${P}.tar.xz"

LICENSE="PHP-3.01
	BSD
	Zend-2.0
	bcmath? ( LGPL-2.1+ )
	fpm? ( BSD-2 )
	gd? ( gd )
	unicode? ( BSD-2 LGPL-2.1 )"

SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

S="${WORKDIR}/${PN}-${MY_PV}"

# We can build the following SAPIs in the given order
SAPIS="embed cli cgi fpm apache2 phpdbg"

# SAPIs and SAPI-specific USE flags (cli SAPI is default on):
IUSE="${IUSE}
	${SAPIS/cli/+cli}
	threads"

IUSE="${IUSE} acl argon2 bcmath berkdb bzip2 calendar cdb cjk
	coverage +ctype curl debug
	enchant exif ffi +fileinfo +filter firebird
	+flatfile ftp gd gdbm gmp +iconv imap inifile
	intl iodbc ipv6 +jit +json kerberos ldap ldap-sasl libedit lmdb
	mhash mssql mysql mysqli nls
	oci8-instant-client odbc +opcache pcntl pdo +phar +posix postgres qdbm
	readline selinux +session session-mm sharedmem
	+simplexml snmp soap sockets sodium spell sqlite ssl
	sysvipc systemd test tidy +tokenizer tokyocabinet truetype unicode webp
	+xml xmlreader xmlwriter xmlrpc xpm xslt zip zlib"

# Without USE=readline or libedit, the interactive "php -a" CLI will hang.
# The Oracle instant client provides its own incompatible ldap library.
REQUIRED_USE="
	|| ( cli cgi fpm apache2 embed phpdbg )
	cli? ( ^^ ( readline libedit ) )
	!cli? ( ?? ( readline libedit ) )
	truetype? ( gd zlib )
	webp? ( gd zlib )
	cjk? ( gd zlib )
	exif? ( gd zlib )
	xpm? ( gd zlib )
	gd? ( zlib )
	simplexml? ( xml )
	soap? ( xml )
	xmlrpc? ( xml iconv )
	xmlreader? ( xml )
	xmlwriter? ( xml )
	xslt? ( xml )
	ldap-sasl? ( ldap )
	oci8-instant-client? ( !ldap )
	qdbm? ( !gdbm )
	session-mm? ( session !threads )
	mysql? ( || ( mysqli pdo ) )
	firebird? ( pdo )
	mssql? ( pdo )
"

RESTRICT="!test? ( test )"

# The supported (that is, autodetected) versions of BDB are listed in
# the ./configure script. Other versions *work*, but we need to stick to
# the ones that can be detected to avoid a repeat of bug #564824.
COMMON_DEPEND="
	>=app-eselect/eselect-php-0.9.1[apache2?,fpm?]
	>=dev-libs/libpcre2-10.30[jit?,unicode]
	fpm? ( acl? ( sys-apps/acl ) )
	apache2? ( www-servers/apache[apache2_modules_unixd(+),threads=] )
	argon2? ( app-crypt/argon2:= )
	berkdb? ( || (  sys-libs/db:5.3 sys-libs/db:4.8 ) )
	bzip2? ( app-arch/bzip2:0= )
	cdb? ( || ( dev-db/cdb dev-db/tinycdb ) )
	coverage? ( dev-util/lcov )
	curl? ( >=net-misc/curl-7.10.5 )
	enchant? ( <app-text/enchant-2.0:0 )
	ffi? ( >=dev-libs/libffi-3.0.11:= )
	firebird? ( dev-db/firebird )
	gd? ( media-libs/libjpeg-turbo:0= media-libs/libpng:0= )
	gdbm? ( >=sys-libs/gdbm-1.8.0:0= )
	gmp? ( dev-libs/gmp:0= )
	iconv? ( virtual/libiconv )
	imap? ( >=virtual/imap-c-client-2[kerberos=,ssl=] )
	intl? ( dev-libs/icu:= )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-1.2.11:= )
	ldap-sasl? ( dev-libs/cyrus-sasl )
	libedit? ( dev-libs/libedit )
	lmdb? ( dev-db/lmdb:= )
	mssql? ( dev-db/freetds[mssql] )
	nls? ( sys-devel/gettext )
	oci8-instant-client? ( dev-db/oracle-instantclient[sdk] )
	odbc? ( iodbc? ( dev-db/libiodbc ) !iodbc? ( >=dev-db/unixODBC-1.8.13 ) )
	postgres? ( dev-db/postgresql:* )
	qdbm? ( dev-db/qdbm )
	readline? ( sys-libs/readline:0= )
	session-mm? ( dev-libs/mm )
	snmp? ( >=net-analyzer/net-snmp-5.2 )
	sodium? ( dev-libs/libsodium:=[-minimal] )
	spell? ( >=app-text/aspell-0.50 )
	sqlite? ( >=dev-db/sqlite-3.7.6.3 )
	ssl? ( >=dev-libs/openssl-1.0.1:0= )
	tidy? ( app-text/htmltidy )
	tokyocabinet? ( dev-db/tokyocabinet )
	truetype? ( =media-libs/freetype-2* )
	unicode? ( dev-libs/oniguruma:= )
	webp? ( media-libs/libwebp:0= )
	xml? ( >=dev-libs/libxml2-2.7.6 )
	xpm? ( x11-libs/libXpm )
	xslt? ( dev-libs/libxslt )
	zip? ( >=dev-libs/libzip-1.2.0:= )
	zlib? ( >=sys-libs/zlib-1.2.0.4:0= )
"

RDEPEND="${COMMON_DEPEND}
	virtual/mta
	fpm? (
		selinux? ( sec-policy/selinux-phpfpm )
		systemd? ( sys-apps/systemd ) )"

# Bison isn't actually needed when building from a release tarball
# However, the configure script will warn if it's absent or if you
# have an incompatible version installed. See bug 593278.
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	>=sys-devel/bison-3.0.1"

BDEPEND="virtual/pkgconfig"

PHP_MV="$(ver_cut 1)"

PATCHES=(
	"${FILESDIR}"/php-iodbc-header-location.patch
	"${FILESDIR}"/bug81656-gcc-11.patch
)

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
		dosym "../ext/opcache.ini" \
			  "${PHP_EXT_INI_DIR_ACTIVE#${EPREFIX}}/opcache.ini"
	fi

	# SAPI-specific handling
	if [[ "${sapi}" == "fpm" ]] ; then
		einfo "Installing FPM config files php-fpm.conf and www.conf"
		insinto "${PHP_INI_DIR#${EPREFIX}}"
		doins sapi/fpm/php-fpm.conf
		insinto "${PHP_INI_DIR#${EPREFIX}}/fpm.d"
		doins sapi/fpm/www.conf
	fi

	dodoc php.ini-{development,production}
}

php_set_ini_dir() {
	PHP_INI_DIR="${EPREFIX}/etc/php/${1}-php${SLOT}"
	PHP_EXT_INI_DIR="${PHP_INI_DIR}/ext"
	PHP_EXT_INI_DIR_ACTIVE="${PHP_INI_DIR}/ext-active"
}

src_prepare() {
	default

	# In php-7.x, the FPM pool configuration files have been split off
	# of the main config. By default the pool config files go in
	# e.g. /etc/php-fpm.d, which isn't slotted. So here we move the
	# include directory to a subdirectory "fpm.d" of $PHP_INI_DIR. Later
	# we'll install the pool configuration file "www.conf" there.
	php_set_ini_dir fpm
	sed -i "s~^include=.*$~include=${PHP_INI_DIR}/fpm.d/*.conf~" \
		sapi/fpm/php-fpm.conf.in \
		|| die 'failed to move the include directory in php-fpm.conf'

	# Emulate buildconf to support cross-compilation
	rm -fr aclocal.m4 autom4te.cache config.cache \
		configure main/php_config.h.in || die
	eautoconf --force
	eautoheader
}

src_configure() {
	filter-lto # bug 855644

	addpredict /usr/share/snmp/mibs/.index #nowarn
	addpredict /var/lib/net-snmp/mib_indexes #nowarn

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
		$(use_with argon2 password-argon2 "${EPREFIX}/usr")
		$(use_enable bcmath)
		$(use_with bzip2 bz2 "${EPREFIX}/usr")
		$(use_enable calendar)
		$(use_enable coverage gcov)
		$(use_enable ctype)
		$(use_with curl)
		$(use_enable xml dom)
		$(use_with enchant)
		$(use_enable exif)
		$(use_with ffi)
		$(use_enable fileinfo)
		$(use_enable filter)
		$(use_enable ftp)
		$(use_with nls gettext "${EPREFIX}/usr")
		$(use_with gmp gmp "${EPREFIX}/usr")
		$(use_with mhash mhash "${EPREFIX}/usr")
		$(use_with iconv iconv \
			$(use elibc_glibc || use elibc_musl || echo "${EPREFIX}/usr"))
		$(use_enable intl)
		$(use_enable ipv6)
		$(use_enable json)
		$(use_with kerberos)
		$(use_with xml libxml)
		$(use_enable unicode mbstring)
		$(use_with ssl openssl)
		$(use_enable pcntl)
		$(use_enable phar)
		$(use_enable pdo)
		$(use_enable opcache)
		$(use_with postgres pgsql "${EPREFIX}/usr")
		$(use_enable posix)
		$(use_with spell pspell "${EPREFIX}/usr")
		$(use_enable simplexml)
		$(use_enable sharedmem shmop)
		$(use_with snmp snmp "${EPREFIX}/usr")
		$(use_enable soap)
		$(use_enable sockets)
		$(use_with sodium)
		$(use_with sqlite sqlite3)
		$(use_enable sysvipc sysvmsg)
		$(use_enable sysvipc sysvsem)
		$(use_enable sysvipc sysvshm)
		$(use_with tidy tidy "${EPREFIX}/usr")
		$(use_enable tokenizer)
		$(use_enable xml)
		$(use_enable xmlreader)
		$(use_enable xmlwriter)
		$(use_with xmlrpc)
		$(use_with xslt xsl)
		$(use_with zip)
		$(use_with zlib zlib "${EPREFIX}/usr")
		$(use_enable debug)
	)

	# DBA support
	if use cdb || use berkdb || use flatfile || use gdbm || use inifile \
		|| use qdbm || use lmdb || use tokyocabinet ; then
		our_conf+=( "--enable-dba" )
	fi

	# DBA drivers support
	our_conf+=(
		$(use_with cdb)
		$(use_with berkdb db4 "${EPREFIX}/usr")
		$(use_enable flatfile)
		$(use_with gdbm gdbm "${EPREFIX}/usr")
		$(use_enable inifile)
		$(use_with qdbm qdbm "${EPREFIX}/usr")
		$(use_with tokyocabinet tcadb "${EPREFIX}/usr")
		$(use_with lmdb lmdb "${EPREFIX}/usr")
	)

	# Support for the GD graphics library
	our_conf+=(
		$(use_with truetype freetype)
		$(use_enable cjk gd-jis-conv)
		$(use_with gd jpeg)
		$(use_with xpm)
		$(use_with webp)
	)
	# enable gd last, so configure can pick up the previous settings
	our_conf+=( $(use_enable gd) )

	# IMAP support
	if use imap ; then
		our_conf+=(
			$(use_with imap imap "${EPREFIX}/usr")
			$(use_with ssl imap-ssl "${EPREFIX}/usr")
		)
	fi

	# LDAP support
	if use ldap ; then
		our_conf+=(
			$(use_with ldap ldap "${EPREFIX}/usr")
			$(use_with ldap-sasl)
		)
	fi

	# MySQL support
	local mysqllib="mysqlnd"
	local mysqlilib="mysqlnd"

	our_conf+=( $(use_with mysqli mysqli "${mysqlilib}") )

	local mysqlsock="${EPREFIX}/var/run/mysqld/mysqld.sock"
	if use mysql || use mysqli ; then
		our_conf+=( $(use_with mysql mysql-sock "${mysqlsock}") )
	fi

	# ODBC support
	if use odbc && use iodbc ; then
		our_conf+=(
			--without-unixODBC
			--with-iodbc
			$(use_with pdo pdo-odbc "iODBC,${EPREFIX}/usr")
		)
	elif use odbc ; then
		our_conf+=(
			--with-unixODBC="${EPREFIX}/usr"
			--without-iodbc
			$(use_with pdo pdo-odbc "unixODBC,${EPREFIX}/usr")
		)
	else
		our_conf+=(
			--without-unixODBC
			--without-iodbc
			--without-pdo-odbc
		)
	fi

	# Oracle support
	our_conf+=( $(use_with oci8-instant-client oci8) )

	# PDO support
	if use pdo ; then
		our_conf+=(
			$(use_with mssql pdo-dblib "${EPREFIX}/usr")
			$(use_with mysql pdo-mysql "${mysqllib}")
			$(use_with postgres pdo-pgsql)
			$(use_with sqlite pdo-sqlite)
			$(use_with firebird pdo-firebird "${EPREFIX}/usr")
			$(use_with oci8-instant-client pdo-oci)
		)
	fi

	# readline/libedit support
	our_conf+=(
		$(use_with readline readline "${EPREFIX}/usr")
		$(use_with libedit)
	)

	# Session support
	if use session ; then
		our_conf+=( $(use_with session-mm mm "${EPREFIX}/usr") )
	else
		our_conf+=( $(use_enable session) )
	fi

	# Use pic for shared modules such as apache2's mod_php
	our_conf+=( --with-pic )

	# we use the system copy of pcre
	# --with-external-pcre affects ext/pcre
	our_conf+=(
		--with-external-pcre
		$(use_with jit pcre-jit)
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

	local one_sapi
	local sapi
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
				cli|cgi|embed|fpm|phpdbg)
					if [[ "${one_sapi}" == "${sapi}" ]] ; then
						sapi_conf+=( "--enable-${sapi}" )
						if [[ "fpm" == "${sapi}" ]] ; then
							sapi_conf+=(
								$(use_with acl fpm-acl)
								$(use_with systemd fpm-systemd)
							)
						fi
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
	addpredict /usr/share/snmp/mibs/.index #nowarn
	addpredict /var/lib/net-snmp/mib_indexes #nowarn

	local sapi
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
	addpredict /usr/share/snmp/mibs/.index #nowarn

	# grab the first SAPI that got built and install common files from there
	local first_sapi="", sapi=""
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

	local file=""
	local sapi_list=""

	for sapi in ${SAPIS}; do
		if use "${sapi}" ; then
			einfo "Installing SAPI: ${sapi}"
			cd "${WORKDIR}/sapis-build/${sapi}" || die

			if [[ "${sapi}" == "apache2" ]] ; then
				# We're specifically not using emake install-sapi as libtool
				# may cause unnecessary relink failures (see bug #351266)
				insinto "${PHP_DESTDIR#${EPREFIX}}/apache2/"
				newins ".libs/libphp${PHP_MV}$(get_libname)" \
					   "libphp${PHP_MV}$(get_libname)"
				keepdir "/usr/$(get_libdir)/apache2/modules"
			else
				# needed each time, php_install_ini would reset it
				local dest="${PHP_DESTDIR#${EPREFIX}}"
				into "${dest}"
				case "$sapi" in
					cli)
						source="sapi/cli/php"
						# Install the "phar" archive utility.
						if use phar ; then
							emake INSTALL_ROOT="${D}" install-pharcmd
							dosym "..${dest#/usr}/bin/phar" "/usr/bin/phar${SLOT}"
						fi
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
					phpdbg)
						source="sapi/phpdbg/phpdbg"
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
					dosym "..${dest#/usr}/bin/${name}" "/usr/bin/${name}${SLOT}"
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

	if [[ -x "${WORKDIR}/sapis-build/cgi/sapi/cgi/php-cgi" ]] ; then
		export TEST_PHP_CGI_EXECUTABLE="${WORKDIR}/sapis-build/cgi/sapi/cgi/php-cgi"
	fi

	if [[ -x "${WORKDIR}/sapis-build/phpdbg/sapi/phpdbg/phpdbg" ]] ; then
		export TEST_PHPDBG_EXECUTABLE="${WORKDIR}/sapis-build/phpdbg/sapi/phpdbg/phpdbg"
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
	local m
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
