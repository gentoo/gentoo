# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
AUTOTOOLS_DEPEND=">=sys-devel/autoconf-2.69"
inherit autotools pam python-single-r1 systemd

MY_PN=${PN}-server
MY_P=${MY_PN}-${PV}
MY_PV=$(ver_rs 1- "_")

DESCRIPTION="Highly configurable free RADIUS server"
HOMEPAGE="https://freeradius.org/"
SRC_URI="https://github.com/FreeRADIUS/freeradius-server/releases/download/release_${MY_PV}/${MY_P}.tar.bz2"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="
	debug firebird iodbc kerberos ldap memcached mysql mongodb odbc oracle pam
	postgres python readline redis samba selinux sqlite ssl systemd
"

RESTRICT="firebird? ( bindist )"

# NOTE: Temporary freeradius doesn't support linking with mariadb client
#       libs also if code is compliant, will be available in the next release.
#       (http://lists.freeradius.org/pipermail/freeradius-devel/2018-October/013228.html)a

# TODO: rlm_mschap works with both samba library or without. I need to avoid
#       linking of samba library if -samba is used.

# TODO: unconditional json-c for now as automagic dep despite efforts to stop it
# ditto libpcap. Can restore USE=rest, USE=pcap if/when fixed.

DEPEND="
	acct-group/radius
	acct-user/radius
	!net-dialup/cistronradius
	dev-libs/libltdl
	dev-libs/libpcre
	dev-libs/json-c:=
	dev-lang/perl:=
	net-libs/libpcap
	net-misc/curl
	sys-libs/gdbm:=
	sys-libs/libcap
	sys-libs/talloc
	virtual/libcrypt:=
	firebird? ( dev-db/firebird )
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	memcached? ( dev-libs/libmemcached )
	mysql? ( dev-db/mysql-connector-c:= )
	mongodb? ( >=dev-libs/mongo-c-driver-1.13.0-r1 )
	odbc? ( dev-db/unixODBC )
	oracle? ( dev-db/oracle-instantclient[sdk] )
	pam? ( sys-libs/pam )
	postgres? ( dev-db/postgresql:= )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
	redis? ( dev-libs/hiredis:= )
	samba? ( net-fs/samba )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( >=dev-libs/openssl-1.0.2:=[-bindist(-)] )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-radius )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# bug #721040
QA_SONAME="usr/lib.*/libfreeradius-.*.so"

QA_CONFIG_IMPL_DECL_SKIP=(
	# Not available on Linux (bug #900048)
	htonll
	htonlll
)

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.20-systemd-service.patch
	"${FILESDIR}"/${PN}-3.2.3-configure-c99.patch
)

pkg_setup() {
	if use python ; then
		python-single-r1_pkg_setup
		export PYTHONBIN="${EPYTHON}"
	fi
}

src_prepare() {
	default

	# Most of the configuration options do not appear as ./configure
	# switches. Instead it identifies the directories that are available
	# and run through them. These might check for the presence of
	# various libraries, in which case they are not built.  To avoid
	# automagic dependencies, we just remove all the modules that we're
	# not interested in using.
	# TODO: shift more of these into configure args below as things
	# are a bit better now.
	use ssl || { rm -r src/modules/rlm_eap/types/rlm_eap_{tls,ttls,peap} || die ; }
	use ldap || { rm -r src/modules/rlm_ldap || die ; }
	use kerberos || { rm -r src/modules/rlm_krb5 || die ; }
	use memcached || { rm -r src/modules/rlm_cache/drivers/rlm_cache_memcached || die ; }
	use pam || { rm -r src/modules/rlm_pam || die ; }

	# Drop support for python2
	rm -r src/modules/rlm_python || die

	use python || { rm -r src/modules/rlm_python3 || die ; }
	#use rest || { rm -r src/modules/rlm_rest || die ; }
	# Do not install ruby rlm module, bug #483108
	rm -r src/modules/rlm_ruby || die

	# These are all things we don't have in portage/I don't want to deal
	# with myself.
	#
	# Requires TNCS library
	rm -r src/modules/rlm_eap/types/rlm_eap_tnc || die
	# Requires libeap-ikev2
	rm -r src/modules/rlm_eap/types/rlm_eap_ikev2 || die
	# Requires some membership.h
	rm -r src/modules/rlm_opendirectory || die
	# ?
	rm -r src/modules/rlm_sql/drivers/rlm_sql_{db2,freetds} || die

	# SQL drivers that are not part of experimental are loaded from a
	# file, so we have to remove them from the file itself when we
	# remove them.
	usesqldriver() {
		local flag=$1
		local driver=rlm_sql_${2:-${flag}}

		if ! use ${flag} ; then
			rm -r src/modules/rlm_sql/drivers/${driver} || die
			sed -i -e /${driver}/d src/modules/rlm_sql/stable || die
		fi
	}

	sed -i \
		-e 's:^#\tuser = :\tuser = :g' \
		-e 's:^#\tgroup = :\tgroup = :g' \
		-e 's:/var/run/radiusd:/run/radiusd:g' \
		-e '/^run_dir/s:${localstatedir}::g' \
		raddb/radiusd.conf.in || die

	# - Verbosity
	# - B uild shared libraries using jlibtool -shared
	sed -i \
		-e 's|--silent ||g' \
		-e 's:--mode=\(compile\|link\):& -shared:g' \
		scripts/libtool.mk || die

	# Crude measure to stop jlibtool from running ranlib and ar
	sed -i \
		-e '/LIBRARIAN/s|".*"|"true"|g' \
		-e '/RANLIB/s|".*"|"true"|g' \
		scripts/jlibtool.c || die

	usesqldriver mysql
	usesqldriver postgres postgresql
	usesqldriver firebird
	usesqldriver iodbc
	usesqldriver odbc unixodbc
	usesqldriver oracle
	usesqldriver sqlite
	usesqldriver mongodb mongo

	eautoreconf
}

src_configure() {
	# Do not try to enable static with static-libs; upstream is a
	# massacre of libtool best practices so you also have to make sure
	# to --enable-shared explicitly.
	local myeconfargs=(
		# Revisit confcache when not needing to use ac_cv anymore
		# for automagic deps.
		#--cache-file="${S}"/config.cache

		--enable-shared
		--disable-ltdl-install
		--disable-silent-rules
		--with-system-libtool
		--with-system-libltdl

		--enable-strict-dependencies
		--without-rlm_couchbase
		--without-rlm_securid
		--without-rlm_unbound
		--without-rlm_idn
		#--without-rlm_json
		#$(use_with rest libfreeradius-json)

		# Our OpenSSL should be patched. Avoid false-positive failures.
		--disable-openssl-version-check
		--with-ascend-binary
		--with-udpfromto
		--with-dhcp
		--with-pcre
		--with-iodbc-include-dir=/usr/include/iodbc
		--with-experimental-modules
		--with-docdir=/usr/share/doc/${PF}
		--with-logdir=/var/log/radius

		$(use_enable debug developer)
		$(use_with ldap edir)
		$(use_with redis rlm_cache_redis)
		$(use_with redis rlm_redis)
		$(use_with redis rlm_rediswho)
		$(use_with ssl openssl)
		$(use_with systemd systemd)
	)

	# bug #77613
	if has_version app-crypt/heimdal ; then
		myeconfargs+=( --enable-heimdal-krb5 )
	fi

	if use python ; then
		myeconfargs+=(
			--with-rlm-python3-bin=${EPYTHON}
			--with-rlm-python3-config-bin=${EPYTHON}-config
		)
	fi

	if ! use readline ; then
		export ac_cv_lib_readline=no
	fi

	#if ! use pcap ; then
	#	export ac_cv_lib_pcap_pcap_open_live=no
	#	export ac_cv_header_pcap_h=no
	#fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	# Verbose, do not generate certificates
	emake \
		Q='' ECHO=true \
		LOCAL_CERT_PRODUCTS=''
}

src_install() {
	dodir /etc

	diropts -m0750 -o root -g radius
	dodir /etc/raddb

	diropts -m0750 -o radius -g radius
	dodir /var/log/radius

	keepdir /var/log/radius/radacct
	diropts

	# - Verbose, do not install certificates
	# - Parallel install fails (bug #509498)
	emake -j1 \
		Q='' ECHO=true \
		LOCAL_CERT_PRODUCTS='' \
		R="${D}" \
		install

	if use pam ; then
		pamd_mimic_system radiusd auth account password session
	fi

	# bug #711756
	fowners -R radius:radius /etc/raddb
	fowners -R radius:radius /var/log/radius

	dodoc CREDITS

	rm "${ED}"/usr/sbin/rc.radiusd || die

	newinitd "${FILESDIR}"/radius.init-r4 radiusd
	newconfd "${FILESDIR}"/radius.conf-r6 radiusd

	if ! use systemd ; then
		# If systemd builtin is not enabled we need use Type=Simple
		# as systemd .service
		sed -i -e 's:^Type=.*::g' \
			-e 's:^WatchdogSec=.*::g' -e 's:^NotifyAccess=all.*::g' \
			"${S}"/debian/freeradius.service
	fi

	systemd_dounit "${S}"/debian/freeradius.service

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}

pkg_config() {
	if use ssl ; then
		cd "${ROOT}"/etc/raddb/certs || die

		./bootstrap || die "Error while running ./bootstrap script."
		chown root:radius "${ROOT}"/etc/raddb/certs || die
		chown root:radius "${ROOT}"/etc/raddb/certs/ca.pem || die
		chown root:radius "${ROOT}"/etc/raddb/certs/server.{key,crt,pem} || die
	fi
}

pkg_preinst() {
	if ! has_version ${CATEGORY}/${PN} && use ssl ; then
		elog "You have to run \`emerge --config =${CATEGORY}/${PF}\` to be able"
		elog "to start the radiusd service."
	fi
}
