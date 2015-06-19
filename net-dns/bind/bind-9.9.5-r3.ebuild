# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/bind/bind-9.9.5-r3.ebuild,v 1.14 2015/03/21 21:34:40 jlec Exp $

# Re dlz/mysql and threads, needs to be verified..
# MySQL uses thread local storage in its C api. Thus MySQL
# requires that each thread of an application execute a MySQL
# thread initialization to setup the thread local storage.
# This is impossible to do safely while staying within the DLZ
# driver API. This is a limitation caused by MySQL, and not the DLZ API.
# Because of this BIND MUST only run with a single thread when
# using the MySQL driver.

EAPI="5"

PYTHON_DEPEND="python? 2:2.7 3"
SUPPORT_PYTHON_ABIS="1"

inherit python eutils autotools toolchain-funcs flag-o-matic multilib db-use user systemd

MY_PV="${PV/_p/-P}"
MY_PV="${MY_PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

SDB_LDAP_VER="1.1.0-fc14"

# bind-9.8.0-P1-geoip-1.3.patch
GEOIP_PV=1.3
#GEOIP_PV_AGAINST="${MY_PV}"
GEOIP_PV_AGAINST="9.9.2"
GEOIP_P="bind-${GEOIP_PV_AGAINST}-geoip-${GEOIP_PV}"
GEOIP_PATCH_A="${GEOIP_P}.patch"
GEOIP_DOC_A="bind-geoip-1.3-readme.txt"
GEOIP_SRC_URI_BASE="http://bind-geoip.googlecode.com/"

RRL_PV="${MY_PV}"

# GeoIP: http://bind-geoip.googlecode.com/
# SDB-LDAP: http://bind9-ldap.bayour.com/

#	geoip? ( ${GEOIP_SRC_URI_BASE}/files/${GEOIP_DOC_A}
#		${GEOIP_SRC_URI_BASE}/files/${GEOIP_PATCH_A} )

DESCRIPTION="BIND - Berkeley Internet Name Domain - Name Server"
HOMEPAGE="http://www.isc.org/software/bind"
SRC_URI="ftp://ftp.isc.org/isc/bind9/${MY_PV}/${MY_P}.tar.gz
	doc? ( mirror://gentoo/dyndns-samples.tbz2 )
	geoip? ( ${GEOIP_SRC_URI_BASE}/files/${GEOIP_DOC_A}
			 http://dev.gentoo.org/~idl0r/${P}-geoip.patch )
	sdb-ldap? (
		http://ftp.disconnected-by-peer.at/pub/bind-sdb-ldap-${SDB_LDAP_VER}.patch.bz2
	)"

LICENSE="GPL-2 ISC BSD BSD-2 HPND JNIC openssl"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="berkdb caps dlz doc filter-aaaa fixed-rrset geoip gost gssapi idn ipv6
ldap mysql odbc postgres python rpz rrl sdb-ldap selinux ssl static-libs threads
urandom xml"
# no PKCS11 currently as it requires OpenSSL to be patched, also see bug 409687

REQUIRED_USE="postgres? ( dlz )
	berkdb? ( dlz )
	mysql? ( dlz !threads )
	odbc? ( dlz )
	ldap? ( dlz )
	sdb-ldap? ( dlz )
	gost? ( ssl )
	threads? ( caps )"

DEPEND="ssl? ( dev-libs/openssl:0[-bindist] )
	mysql? ( >=virtual/mysql-4.0 )
	odbc? ( >=dev-db/unixODBC-2.2.6 )
	ldap? ( net-nds/openldap )
	idn? ( net-dns/idnkit )
	postgres? ( dev-db/postgresql:= )
	caps? ( >=sys-libs/libcap-2.1.0 )
	xml? ( dev-libs/libxml2 )
	geoip? ( >=dev-libs/geoip-1.4.6 )
	gssapi? ( virtual/krb5 )
	sdb-ldap? ( net-nds/openldap )
	gost? ( >=dev-libs/openssl-1.0.0:0[-bindist] )"

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-bind )
	|| ( sys-process/psmisc >=sys-freebsd/freebsd-ubin-9.0_rc sys-process/fuser-bsd )"

S="${WORKDIR}/${MY_P}"

# bug 479092, requires networking
RESTRICT="test"

pkg_setup() {
	ebegin "Creating named group and user"
	enewgroup named 40
	enewuser named 40 -1 /etc/bind named
	eend ${?}

	if use python; then
		python_pkg_setup
	fi
}

src_prepare() {
	# Adjusting PATHs in manpages
	for i in bin/{named/named.8,check/named-checkconf.8,rndc/rndc.8} ; do
		sed -i \
			-e 's:/etc/named.conf:/etc/bind/named.conf:g' \
			-e 's:/etc/rndc.conf:/etc/bind/rndc.conf:g' \
			-e 's:/etc/rndc.key:/etc/bind/rndc.key:g' \
			"${i}" || die "sed failed, ${i} doesn't exist"
	done

	if use dlz; then
		# bind fails to reconnect to MySQL5 databases, bug #180720, patch by Nicolas Brousse
		# (http://www.shell-tips.com/2007/09/04/bind-950-patch-dlz-mysql-5-for-auto-reconnect/)
		if use mysql && has_version ">=dev-db/mysql-5"; then
			epatch "${FILESDIR}"/bind-dlzmysql5-reconnect.patch
		fi

		if use odbc; then
			epatch "${FILESDIR}/${PN}-9.7.3-odbc-dlz-detect.patch"
		fi

		# sdb-ldap patch as per  bug #160567
		# Upstream URL: http://bind9-ldap.bayour.com/
		# New patch take from bug 302735
		if use sdb-ldap; then
			epatch "${WORKDIR}"/${PN}-sdb-ldap-${SDB_LDAP_VER}.patch
			cp -fp contrib/sdb/ldap/ldapdb.[ch] bin/named/
			cp -fp contrib/sdb/ldap/{ldap2zone.1,ldap2zone.c} bin/tools/
			cp -fp contrib/sdb/ldap/{zone2ldap.1,zone2ldap.c} bin/tools/
		fi
	fi

	# should be installed by bind-tools
	sed -i -r -e "s:(nsupdate|dig) ::g" bin/Makefile.in || die

	if use geoip; then
#		cp "${DISTDIR}"/${GEOIP_PATCH_A} "${S}" || die
#		sed -i -e 's:^ RELEASETYPE=: RELEASETYPE=-P:' \
#			-e 's:RELEASEVER=:RELEASEVER=2:' \
#			${GEOIP_PATCH_A} || die
#		sed -i -e 's:^ PATCHVER=2: PATCHVER=4:' ${GEOIP_PATCH_A} || die
#		epatch -F0 ${GEOIP_PATCH_A}
		epatch -F0 "${DISTDIR}/${P}-geoip.patch"
	fi

	# Disable tests for now, bug 406399
	sed -i '/^SUBDIRS/s:tests::' bin/Makefile.in lib/Makefile.in || die

	# bug #220361
	rm aclocal.m4
	rm -rf libtool.m4/
	eautoreconf
}

src_configure() {
	local myconf=""

	if use urandom; then
		myconf="${myconf} --with-randomdev=/dev/urandom"
	else
		myconf="${myconf} --with-randomdev=/dev/random"
	fi

	use geoip && myconf="${myconf} --with-geoip"

	# bug #158664
#	gcc-specs-ssp && replace-flags -O[23s] -O

	# To include db.h from proper path
	use berkdb && append-flags "-I$(db_includedir)"

	export BUILD_CC=$(tc-getBUILD_CC)
	econf \
		--sysconfdir=/etc/bind \
		--localstatedir=/var \
		--with-libtool \
		--enable-full-report \
		$(use_enable threads) \
		$(use_with dlz dlopen) \
		$(use_with dlz dlz-filesystem) \
		$(use_with dlz dlz-stub) \
		$(use_with postgres dlz-postgres) \
		$(use_with mysql dlz-mysql) \
		$(use_with berkdb dlz-bdb) \
		$(use_with ldap dlz-ldap) \
		$(use_with odbc dlz-odbc) \
		$(use_with ssl openssl "${EPREFIX}"/usr) \
		$(use_with ssl ecdsa) \
		$(use_with idn) \
		$(use_enable ipv6) \
		$(use_with xml libxml2) \
		$(use_enable xml newstats) \
		$(use_with gssapi) \
		$(use_enable rpz rpz-nsip) \
		$(use_enable rpz rpz-nsdname) \
		$(use_enable caps linux-caps) \
		$(use_with gost) \
		$(use_enable filter-aaaa) \
		$(use_enable fixed-rrset) \
		$(use_enable rrl) \
		$(use_with python) \
		--without-readline \
		${myconf}

	# $(use_enable static-libs static) \

	# bug #151839
	echo '#undef SO_BSDCOMPAT' >> config.h
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc CHANGES FAQ README

	if use idn; then
		dodoc contrib/idn/README.idnkit
	fi

	if use doc; then
		dodoc doc/arm/Bv9ARM.pdf

		docinto misc
		dodoc doc/misc/*

		# might a 'html' useflag make sense?
		docinto html
		dohtml -r doc/arm/*

		docinto contrib
		dodoc contrib/named-bootconf/named-bootconf.sh \
			contrib/nanny/nanny.pl

		# some handy-dandy dynamic dns examples
		pushd "${D}"/usr/share/doc/${PF} 1>/dev/null
		tar xf "${DISTDIR}"/dyndns-samples.tbz2 || die
		popd 1>/dev/null
	fi

	use geoip && dodoc "${DISTDIR}"/${GEOIP_DOC_A}

	insinto /etc/bind
	newins "${FILESDIR}"/named.conf-r7 named.conf

	# ftp://ftp.rs.internic.net/domain/named.cache:
	insinto /var/bind
	doins "${FILESDIR}"/named.cache

	insinto /var/bind/pri
	newins "${FILESDIR}"/127.zone-r1 127.zone
	newins "${FILESDIR}"/localhost.zone-r3 localhost.zone

	newinitd "${FILESDIR}"/named.init-r13 named
	newconfd "${FILESDIR}"/named.confd-r7 named

	if use gost; then
		sed -i -e 's/^OPENSSL_LIBGOST=${OPENSSL_LIBGOST:-0}$/OPENSSL_LIBGOST=${OPENSSL_LIBGOST:-1}/' "${D}/etc/init.d/named" || die
	else
		sed -i -e 's/^OPENSSL_LIBGOST=${OPENSSL_LIBGOST:-1}$/OPENSSL_LIBGOST=${OPENSSL_LIBGOST:-0}/' "${D}/etc/init.d/named" || die
	fi

	newenvd "${FILESDIR}"/10bind.env 10bind

	# Let's get rid of those tools and their manpages since they're provided by bind-tools
	rm -f "${D}"/usr/share/man/man1/{dig,host,nslookup}.1*
	rm -f "${D}"/usr/share/man/man8/{dnssec-keygen,nsupdate}.8*
	rm -f "${D}"/usr/bin/{dig,host,nslookup,dnssec-keygen,nsupdate}
	rm -f "${D}"/usr/sbin/{dig,host,nslookup,dnssec-keygen,nsupdate}

	# bug 405251, library archives aren't properly handled by --enable/disable-static
	if ! use static-libs; then
		find "${D}" -type f -name '*.a' -delete || die
	fi

	# bug 405251
	find "${D}" -type f -name '*.la' -delete || die

	if use python; then
		install_python_tools() {
			python_convert_shebangs $PYTHON_ABI bin/python/dnssec-checkds bin/python/dnssec-coverage
			newsbin bin/python/dnssec-checkds dnssec-checkds-${PYTHON_ABI}
			newsbin bin/python/dnssec-coverage dnssec-coverage-${PYTHON_ABI}
		}
		python_execute_function install_python_tools

		rm -f "${D}/usr/sbin/dnssec-"{checkds,coverage}
		python_generate_wrapper_scripts "${D}usr/sbin/dnssec-checkds"
		python_generate_wrapper_scripts "${D}usr/sbin/dnssec-coverage"
	fi

	# bug 450406
	dosym named.cache /var/bind/root.cache

	dosym /var/bind/pri /etc/bind/pri
	dosym /var/bind/sec /etc/bind/sec
	dosym /var/bind/dyn /etc/bind/dyn
	keepdir /var/bind/{pri,sec,dyn}

	dodir /var/log/named

	fowners root:named /{etc,var}/bind /var/log/named /var/bind/{sec,pri,dyn}
	fowners root:named /var/bind/named.cache /var/bind/pri/{127,localhost}.zone /etc/bind/{bind.keys,named.conf}
	fperms 0640 /var/bind/named.cache /var/bind/pri/{127,localhost}.zone /etc/bind/{bind.keys,named.conf}
	fperms 0750 /etc/bind /var/bind/pri
	fperms 0770 /var/log/named /var/bind/{,sec,dyn}

	systemd_newunit "${FILESDIR}/named.service-r1" named.service
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
		chown root:named /etc/bind/rndc.key
		chmod 0640 /etc/bind/rndc.key
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

	ewarn
	ewarn "NOTE: /var/bind/named.ca has been renamed to /var/bind/named.cache"
	ewarn "you may need to fix your named.conf!"
	ewarn
	ewarn "NOTE: If you upgrade from <net-dns/bind-9.4.3_p5-r1, you may encounter permission problems"
	ewarn "To fix the permissions do:"
	ewarn "chown root:named /{etc,var}/bind /run/named/ /var/log/named /var/bind/{sec,pri,dyn}"
	ewarn "chown root:named /var/bind/named.cache /var/bind/pri/{127,localhost}.zone /etc/bind/{bind.keys,named.conf}"
	ewarn "chmod 0640 /var/bind/named.cache /var/bind/pri/{127,localhost}.zone /etc/bind/{bind.keys,named.conf}"
	ewarn "chmod 0750 /etc/bind /var/bind/pri"
	ewarn "chmod 0770 /run/named/ /var/log/named /var/bind/{,sec,dyn}"
	ewarn
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

	mkdir -m 0750 -p ${CHROOT}
	mkdir -m 0755 -p ${CHROOT}/{dev,etc,var/log,run}
	mkdir -m 0750 -p ${CHROOT}/etc/bind
	mkdir -m 0770 -p ${CHROOT}/var/{bind,log/named} ${CHROOT}/run/named/
	# As of bind 9.8.0
	if has_version net-dns/bind[gost]; then
		if [ "$(get_libdir)" = "lib64" ]; then
			mkdir -m 0755 -p ${CHROOT}/usr/lib64/engines
			ln -s lib64 ${CHROOT}/usr/lib
		else
			mkdir -m 0755 -p ${CHROOT}/usr/lib/engines
		fi
	fi
	chown root:named ${CHROOT} ${CHROOT}/var/{bind,log/named} ${CHROOT}/run/named/ ${CHROOT}/etc/bind

	mknod ${CHROOT}/dev/null c 1 3
	chmod 0666 ${CHROOT}/dev/null

	mknod ${CHROOT}/dev/zero c 1 5
	chmod 0666 ${CHROOT}/dev/zero

	if use urandom; then
		mknod ${CHROOT}/dev/urandom c 1 9
		chmod 0666 ${CHROOT}/dev/urandom
	else
		mknod ${CHROOT}/dev/random c 1 8
		chmod 0666 ${CHROOT}/dev/random
	fi

	if [ "${CHROOT_NOMOUNT:-0}" -ne 0 ]; then
		cp -a /etc/bind ${CHROOT}/etc/
		cp -a /var/bind ${CHROOT}/var/
	fi

	if [ "${CHROOT_GEOIP:-0}" -eq 1 ]; then
		mkdir -m 0755 -p ${CHROOT}/usr/share/GeoIP
	fi

	elog "You may need to add the following line to your syslog-ng.conf:"
	elog "source jail { unix-stream(\"${CHROOT}/dev/log\"); };"
}
