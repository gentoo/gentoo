# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Re dlz/mysql and threads, needs to be verified..
# MySQL uses thread local storage in its C api. Thus MySQL
# requires that each thread of an application execute a MySQL
# thread initialization to setup the thread local storage.
# This is impossible to do safely while staying within the DLZ
# driver API. This is a limitation caused by MySQL, and not the DLZ API.
# Because of this BIND MUST only run with a single thread when
# using the MySQL driver.

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit python-r1 eutils autotools toolchain-funcs flag-o-matic multilib db-use user systemd

MY_PV="${PV/_p/-P}"
MY_PV="${MY_PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

SDB_LDAP_VER="1.1.0-fc14"

RRL_PV="${MY_PV}"

# SDB-LDAP: http://bind9-ldap.bayour.com/

DESCRIPTION="Berkeley Internet Name Domain - Name Server"
HOMEPAGE="https://www.isc.org/software/bind"
SRC_URI="https://downloads.isc.org/isc/bind9/${PV}/${P}.tar.gz
	doc? ( mirror://gentoo/dyndns-samples.tbz2 )"
#	sdb-ldap? (
#		http://ftp.disconnected-by-peer.at/pub/bind-sdb-ldap-${SDB_LDAP_VER}.patch.bz2
#	)"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 HPND ISC MPL-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
# -berkdb by default re bug 602682
IUSE="-berkdb +caps dlz dnstap doc dnsrps fixed-rrset geoip geoip2 gssapi
json ldap libressl lmdb mysql odbc postgres python selinux static-libs
urandom xml +zlib"
# sdb-ldap - patch broken
# no PKCS11 currently as it requires OpenSSL to be patched, also see bug 409687

REQUIRED_USE="
	?? ( geoip geoip2 )
	postgres? ( dlz )
	berkdb? ( dlz )
	mysql? ( dlz )
	odbc? ( dlz )
	ldap? ( dlz )
	dnsrps? ( dlz )
	python? ( ${PYTHON_REQUIRED_USE} )"
# sdb-ldap? ( dlz )

DEPEND="!libressl? ( dev-libs/openssl:=[-bindist] )
	libressl? ( dev-libs/libressl:= )
	mysql? ( dev-db/mysql-connector-c:0= )
	odbc? ( >=dev-db/unixODBC-2.2.6 )
	ldap? ( net-nds/openldap )
	postgres? ( dev-db/postgresql:= )
	caps? ( >=sys-libs/libcap-2.1.0 )
	xml? ( dev-libs/libxml2 )
	geoip? ( >=dev-libs/geoip-1.4.6 )
	geoip2? ( dev-libs/libmaxminddb )
	gssapi? ( virtual/krb5 )
	json? ( dev-libs/json-c:= )
	lmdb? ( dev-db/lmdb )
	zlib? ( sys-libs/zlib )
	dnstap? ( dev-libs/fstrm dev-libs/protobuf-c )
	python? (
		${PYTHON_DEPS}
		dev-python/ply[${PYTHON_USEDEP}]
	)"
#	sdb-ldap? ( net-nds/openldap )

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-bind )
	sys-process/psmisc"

S="${WORKDIR}/${MY_P}"

# bug 479092, requires networking
RESTRICT="test"

pkg_setup() {
	ebegin "Creating named group and user"
	enewgroup named 40
	enewuser named 40 -1 /etc/bind named
	eend ${?}
}

src_prepare() {
	default

	export LDFLAGS="${LDFLAGS} -L${EPREFIX}/usr/$(get_libdir) -ldl"

	# Adjusting PATHs in manpages
	for i in bin/{named/named.8,check/named-checkconf.8,rndc/rndc.8} ; do
		sed -i \
			-e 's:/etc/named.conf:/etc/bind/named.conf:g' \
			-e 's:/etc/rndc.conf:/etc/bind/rndc.conf:g' \
			-e 's:/etc/rndc.key:/etc/bind/rndc.key:g' \
			"${i}" || die "sed failed, ${i} doesn't exist"
	done

#	if use dlz; then
#		# sdb-ldap patch as per  bug #160567
#		# Upstream URL: http://bind9-ldap.bayour.com/
#		# New patch take from bug 302735
#		if use sdb-ldap; then
#			epatch "${WORKDIR}"/${PN}-sdb-ldap-${SDB_LDAP_VER}.patch
#			cp -fp contrib/sdb/ldap/ldapdb.[ch] bin/named/
#			cp -fp contrib/sdb/ldap/{ldap2zone.1,ldap2zone.c} bin/tools/
#			cp -fp contrib/sdb/ldap/{zone2ldap.1,zone2ldap.c} bin/tools/
#		fi
#	fi

	# should be installed by bind-tools
	sed -i -r -e "s:(nsupdate|dig|delv) ::g" bin/Makefile.in || die

	# Disable tests for now, bug 406399
	sed -i '/^SUBDIRS/s:tests::' bin/Makefile.in lib/Makefile.in || die

	# bug #220361
	rm aclocal.m4 || die
	rm -rf libtool.m4/ || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir=/etc/bind
		--localstatedir=/var
		--with-libtool
		--enable-full-report
		--without-readline
		--with-openssl="${EPREFIX}"/usr
		$(use_enable caps linux-caps)
		$(use_enable dnsrps)
		$(use_enable dnstap)
		$(use_enable fixed-rrset)
		# $(use_enable static-libs static)
		$(use_with berkdb dlz-bdb)
		$(use_with dlz dlopen)
		$(use_with dlz dlz-filesystem)
		$(use_with dlz dlz-stub)
		$(use_with gssapi)
		$(use_with json libjson)
		$(use_with ldap dlz-ldap)
		$(use_with mysql dlz-mysql)
		$(use_with odbc dlz-odbc)
		$(use_with postgres dlz-postgres)
		$(use_with lmdb)
		$(use_with python)
		$(use_with xml libxml2)
		$(use_with zlib)
	)

	use geoip && myeconfargs+=( --with-geoip )
	use geoip2 && myeconfargs+=( --with-geoip2 )

	# bug #158664
#	gcc-specs-ssp && replace-flags -O[23s] -O

	# To include db.h from proper path
	use berkdb && append-flags "-I$(db_includedir)"

	export BUILD_CC=$(tc-getBUILD_CC)
	econf "${myeconfargs[@]}"

	# bug #151839
	echo '#undef SO_BSDCOMPAT' >> config.h
}

src_install() {
	default

	dodoc CHANGES README

	if use doc; then
		dodoc doc/arm/Bv9ARM.pdf

		docinto misc
		dodoc -r doc/misc/

		# might a 'html' useflag make sense?
		docinto html
		dodoc -r doc/arm/

		docinto contrib
		dodoc contrib/scripts/{nanny.pl,named-bootconf.sh}

		# some handy-dandy dynamic dns examples
		pushd "${ED}"/usr/share/doc/${PF} 1>/dev/null || die
		tar xf "${DISTDIR}"/dyndns-samples.tbz2 || die
		popd 1>/dev/null || die
	fi

	insinto /etc/bind
	newins "${FILESDIR}"/named.conf-r8 named.conf

	# ftp://ftp.rs.internic.net/domain/named.cache:
	insinto /var/bind
	newins "${FILESDIR}"/named.cache-r3 named.cache

	insinto /var/bind/pri
	newins "${FILESDIR}"/localhost.zone-r3 localhost.zone

	newinitd "${FILESDIR}"/named.init-r13 named
	newconfd "${FILESDIR}"/named.confd-r7 named

	newenvd "${FILESDIR}"/10bind.env 10bind

	# Let's get rid of those tools and their manpages since they're provided by bind-tools
	rm -f "${ED}"/usr/share/man/man1/{dig,host,nslookup}.1* || die
	rm -f "${ED}"/usr/share/man/man8/nsupdate.8* || die
	rm -f "${ED}"/usr/bin/{dig,host,nslookup,nsupdate} || die
	rm -f "${ED}"/usr/sbin/{dig,host,nslookup,nsupdate} || die
	for tool in dsfromkey importkey keyfromlabel keygen \
	revoke settime signzone verify; do
		rm -f "${ED}"/usr/{,s}bin/dnssec-"${tool}" || die
		rm -f "${ED}"/usr/share/man/man8/dnssec-"${tool}".8* || die
	done

	# bug 405251, library archives aren't properly handled by --enable/disable-static
	if ! use static-libs; then
		find "${ED}" -type f -name '*.a' -delete || die
	fi

	# bug 405251
	find "${ED}" -type f -name '*.la' -delete || die

	if use python; then
		install_python_tools() {
			dosbin bin/python/dnssec-{checkds,coverage}
		}
		python_foreach_impl install_python_tools

		python_replicate_script "${ED}/usr/sbin/dnssec-checkds"
		python_replicate_script "${ED}/usr/sbin/dnssec-coverage"
	fi

	# bug 450406
	dosym named.cache /var/bind/root.cache

	dosym ../../var/bind/pri /etc/bind/pri
	dosym ../../var/bind/sec /etc/bind/sec
	dosym ../../var/bind/dyn /etc/bind/dyn
	keepdir /var/bind/{pri,sec,dyn}

	dodir /var/log/named

	fowners root:named /{etc,var}/bind /var/log/named /var/bind/{sec,pri,dyn}
	fowners root:named /var/bind/named.cache /var/bind/pri/localhost.zone /etc/bind/{bind.keys,named.conf}
	fperms 0640 /var/bind/named.cache /var/bind/pri/localhost.zone /etc/bind/{bind.keys,named.conf}
	fperms 0750 /etc/bind /var/bind/pri
	fperms 0770 /var/log/named /var/bind/{,sec,dyn}

	systemd_newunit "${FILESDIR}/named.service-r1" named.service
	systemd_dotmpfilesd "${FILESDIR}"/named.conf
	exeinto /usr/libexec
	doexe "${FILESDIR}/generate-rndc-key.sh"
}

pkg_postinst() {
	if [ ! -f '/etc/bind/rndc.key' ]; then
		if use urandom; then
			einfo "Using /dev/urandom for generating rndc.key"
			/usr/sbin/rndc-confgen -r /dev/urandom -a
			echo
		else
			einfo "Using /dev/random for generating rndc.key"
			/usr/sbin/rndc-confgen -a
			echo
		fi
		chown root:named /etc/bind/rndc.key || die
		chmod 0640 /etc/bind/rndc.key || die
	fi

	einfo
	einfo "You can edit /etc/conf.d/named to customize named settings"
	einfo
	use mysql || use postgres || use ldap && {
		elog "If your named depends on MySQL/PostgreSQL or LDAP,"
		elog "uncomment the specified rc_named_* lines in your"
		elog "/etc/conf.d/named config to ensure they'll start before bind"
		einfo
	}
	einfo "If you'd like to run bind in a chroot AND this is a new"
	einfo "install OR your bind doesn't already run in a chroot:"
	einfo "1) Uncomment and set the CHROOT variable in /etc/conf.d/named."
	einfo "2) Run \`emerge --config '=${CATEGORY}/${PF}'\`"
	einfo

	CHROOT=$(source /etc/conf.d/named 2>/dev/null; echo ${CHROOT})
	if [[ -n ${CHROOT} ]]; then
		elog "NOTE: As of net-dns/bind-9.4.3_p5-r1 the chroot part of the init-script got some major changes!"
		elog "To enable the old behaviour (without using mount) uncomment the"
		elog "CHROOT_NOMOUNT option in your /etc/conf.d/named config."
		elog "If you decide to use the new/default method, ensure to make backup"
		elog "first and merge your existing configs/zones to /etc/bind and"
		elog "/var/bind because bind will now mount the needed directories into"
		elog "the chroot dir."
	fi
}

pkg_config() {
	CHROOT=$(source /etc/conf.d/named; echo ${CHROOT})
	CHROOT_NOMOUNT=$(source /etc/conf.d/named; echo ${CHROOT_NOMOUNT})
	CHROOT_GEOIP=$(source /etc/conf.d/named; echo ${CHROOT_GEOIP})

	if [[ -z "${CHROOT}" ]]; then
		eerror "This config script is designed to automate setting up"
		eerror "a chrooted bind/named. To do so, please first uncomment"
		eerror "and set the CHROOT variable in '/etc/conf.d/named'."
		die "Unset CHROOT"
	fi
	if [[ -d "${CHROOT}" ]]; then
		ewarn "NOTE: As of net-dns/bind-9.4.3_p5-r1 the chroot part of the init-script got some major changes!"
		ewarn "To enable the old behaviour (without using mount) uncomment the"
		ewarn "CHROOT_NOMOUNT option in your /etc/conf.d/named config."
		ewarn
		ewarn "${CHROOT} already exists... some things might become overridden"
		ewarn "press CTRL+C if you don't want to continue"
		sleep 10
	fi

	echo; einfo "Setting up the chroot directory..."

	mkdir -m 0750 -p ${CHROOT} || die
	mkdir -m 0755 -p ${CHROOT}/{dev,etc,var/log,run} || die
	mkdir -m 0750 -p ${CHROOT}/etc/bind || die
	mkdir -m 0770 -p ${CHROOT}/var/{bind,log/named} ${CHROOT}/run/named/ || die

	chown root:named \
		${CHROOT} \
		${CHROOT}/var/{bind,log/named} \
		${CHROOT}/run/named/ \
		${CHROOT}/etc/bind \
		|| die

	mknod ${CHROOT}/dev/null c 1 3 || die
	chmod 0666 ${CHROOT}/dev/null || die

	mknod ${CHROOT}/dev/zero c 1 5 || die
	chmod 0666 ${CHROOT}/dev/zero || die

	if use urandom; then
		mknod ${CHROOT}/dev/urandom c 1 9 || die
		chmod 0666 ${CHROOT}/dev/urandom || die
	else
		mknod ${CHROOT}/dev/random c 1 8 || die
		chmod 0666 ${CHROOT}/dev/random || die
	fi

	if [ "${CHROOT_NOMOUNT:-0}" -ne 0 ]; then
		cp -a /etc/bind ${CHROOT}/etc/ || die
		cp -a /var/bind ${CHROOT}/var/ || die
	fi

	if [ "${CHROOT_GEOIP:-0}" -eq 1 ]; then
		if use geoip; then
			mkdir -m 0755 -p ${CHROOT}/usr/share/GeoIP || die
		elif use geoip2; then
			mkdir -m 0755 -p ${CHROOT}/usr/share/GeoIP2 || die
		fi
	fi

	elog "You may need to add the following line to your syslog-ng.conf:"
	elog "source jail { unix-stream(\"${CHROOT}/dev/log\"); };"
}
