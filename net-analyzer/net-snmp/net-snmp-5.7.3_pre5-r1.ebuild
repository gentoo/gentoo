# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.7.3_pre5-r1.ebuild,v 1.14 2015/04/08 18:01:22 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=yesplz
DISTUTILS_OPTIONAL=yesplz
WANT_AUTOMAKE=none
PATCHSET=1

inherit autotools distutils-r1 eutils perl-module systemd

DESCRIPTION="Software for generating and retrieving SNMP data"
HOMEPAGE="http://net-snmp.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${PN}/${PV/_pre*/}-pre-releases/${P/_pre*/}.${PV/*_}.tar.gz
	http://dev.gentoo.org/~jer/${PN}-5.7.3-patches-${PATCHSET}.tar.xz
"

S=${WORKDIR}/${P/_/.}

# GPL-2 for the init scripts
LICENSE="HPND BSD GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="bzip2 doc elf ipv6 mfd-rewrites minimal perl python rpm selinux ssl tcpd X zlib lm_sensors ucd-compat pci netlink mysql"

COMMON="ssl? ( >=dev-libs/openssl-0.9.6d )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	rpm? (
		app-arch/rpm
		dev-libs/popt
	)
	bzip2? ( app-arch/bzip2 )
	zlib? ( >=sys-libs/zlib-1.1.4 )
	elf? ( dev-libs/elfutils )
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	pci? ( sys-apps/pciutils )
	lm_sensors? ( sys-apps/lm_sensors )
	netlink? ( dev-libs/libnl:3 )
	mysql? ( virtual/mysql )"

RDEPEND="${COMMON}
	perl? (
		X? ( dev-perl/perl-tk )
		!minimal? ( dev-perl/TermReadKey )
	)
	selinux? ( sec-policy/selinux-snmp )
"

# Dependency on autoconf due to bug #225893
DEPEND="${COMMON}
	>=sys-apps/sed-4
	doc? ( app-doc/doxygen )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	rpm? ( bzip2 zlib )
"

RESTRICT=test

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# snmpconf generates config files with proper selinux context
	use selinux && epatch "${FILESDIR}"/${PN}-5.1.2-snmpconf-selinux.patch

	epatch "${WORKDIR}"/patches/*.patch

	epatch_user

	eautoconf
}

src_configure() {
	# keep this in the same line, configure.ac arguments are passed down to config.h
	local mibs="host ucd-snmp/dlmod ucd-snmp/diskio ucd-snmp/extensible mibII/mta_sendmail smux"
	use lm_sensors && mibs="${mibs} ucd-snmp/lmsensorsMib"

	econf \
		$(use_enable !ssl internal-md5) \
		$(use_enable ipv6) \
		$(use_enable mfd-rewrites) \
		$(use_enable perl embedded-perl) \
		$(use_enable ucd-compat ucd-snmp-compatibility) \
		$(use_with bzip2) \
		$(use_with elf) \
		$(use_with mysql) \
		$(use_with netlink nl) \
		$(use_with pci) \
		$(use_with perl perl-modules INSTALLDIRS=vendor) \
		$(use_with python python-modules) \
		$(use_with rpm) \
		$(use_with ssl openssl) \
		$(use_with tcpd libwrap) \
		$(use_with zlib) \
		--enable-shared --disable-static \
		--with-default-snmp-version="3" \
		--with-install-prefix="${D}" \
		--with-ldflags="${LDFLAGS}" \
		--with-logfile="/var/log/net-snmpd.log" \
		--with-mib-modules="${mibs}" \
		--with-persistent-directory="/var/lib/net-snmp" \
		--with-sys-contact="root@Unknown" \
		--with-sys-location="Unknown"
}

src_compile() {
	emake \
		OTHERLDFLAGS="${LDFLAGS}" \
		sedscript all

	use doc && emake docsdox
}

src_install () {
	# bug #317965
	emake -j1 DESTDIR="${D}" install

	if use perl ; then
		perl_delete_localpod
		use X || rm -f "${D}"/usr/bin/tkmib
	else
		rm -f "${D}"/usr/bin/mib2c "${D}"/usr/bin/snmpcheck "${D}"/usr/bin/tkmib
	fi

	dodoc AGENT.txt ChangeLog FAQ INSTALL NEWS PORTING README* TODO
	newdoc EXAMPLE.conf.def EXAMPLE.conf

	use doc && dohtml docs/html/*

	keepdir /var/lib/net-snmp

	newinitd "${FILESDIR}"/snmpd.init.2 snmpd
	newconfd "${FILESDIR}"/snmpd.conf snmpd

	newinitd "${FILESDIR}"/snmptrapd.init.2 snmptrapd
	newconfd "${FILESDIR}"/snmptrapd.conf snmptrapd

	systemd_dounit "${FILESDIR}"/snmpd.service
	systemd_dounit "${FILESDIR}"/snmptrapd.service

	insinto /etc/snmp
	newins "${S}"/EXAMPLE.conf snmpd.conf.example

	# Remove everything not required for an agent.
	# Keep only the snmpd, snmptrapd, MIBs, headers and libraries.
	if use minimal; then
		rm -rf \
			"${D}"/usr/bin/{encode_keychange,snmp{get,getnext,set,usm,walk,bulkwalk,table,trap,bulkget,translate,status,delta,test,df,vacm,netstat,inform,check,conf},fixproc,traptoemail} \
			"${D}"/usr/share/snmp/snmpconf-data \
			"${D}"/usr/share/snmp/*.conf \
			"${D}"/**/*.pl
	fi
}
