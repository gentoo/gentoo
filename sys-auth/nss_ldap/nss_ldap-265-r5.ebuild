# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/nss_ldap/nss_ldap-265-r5.ebuild,v 1.12 2014/11/14 21:18:02 maekke Exp $

EAPI=5
inherit fixheadtails eutils multilib multilib-minimal autotools prefix

IUSE="debug ssl sasl kerberos"

DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/nss_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux"

DEPEND=">=net-nds/openldap-2.4.38-r1[${MULTILIB_USEDEP}]
		sasl? ( >=dev-libs/cyrus-sasl-2.1.26-r3[${MULTILIB_USEDEP}] )
		kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
		ssl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
		!<net-fs/autofs-4.1.3
		abi_x86_32? (
			!<=app-emulation/emul-linux-x86-baselibs-20140508-r7
			!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
		)"

src_prepare() {
	if use prefix; then
		epatch "${FILESDIR}"/${P}-installdir.patch
		eprefixify Makefile.am
	fi

	# bug 438692
	epatch "${FILESDIR}"/${P}-pthread.patch

	epatch "${FILESDIR}"/nsswitch.ldap.diff

	# Applied by upstream
	#epatch "${FILESDIR}"/${PN}-239-tls-security-bug.patch

	epatch "${FILESDIR}"/${PN}-249-sasl-compile.patch

	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${PN}-265-reconnect-timeouts.patch

	# Applied by upstream
	#EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${PN}-254-nss_getgrent_skipmembers.patch

	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${PN}-257-nss_max_group_depth.patch

	sed -i.orig \
		-e '/^ @(#)\$Id: ldap.conf,v/s,^,#,' \
		"${S}"/ldap.conf

	# fix head/tail stuff
	ht_fix_file "${S}"/Makefile.am "${S}"/Makefile.in "${S}"/depcomp

	# fix build borkage
	for i in Makefile.{in,am}; do
	  sed -i.orig \
	    -e '/^install-exec-local: nss_ldap.so/s,nss_ldap.so,,g' \
	    "${S}"/$i
	done

	epatch "${FILESDIR}"/${PN}-257.2-gssapi-headers.patch

	# Bug #214750, no automagic deps
	epatch "${FILESDIR}"/${PN}-264-disable-automagic.patch

	# Upstream forgets the version number sometimes
	#sed -i \
	#	-e "/^AM_INIT_AUTOMAKE/s~2..~$PV~" \
	#	"${S}"/configure.in

	# Include an SONAME
	epatch "${FILESDIR}"/${PN}-254-soname.patch

	#fix broken oneshot connections
	epatch "${FILESDIR}/nss_ldap-265-missing-entries-oneshot.patch"

	sed -i \
		-e 's, vers_string , PERL5LIB="@top_srcdir@" @top_srcdir@/vers_string ,g' \
		"${S}"/Makefile.am

	if use kernel_FreeBSD; then
		#fix broken fbsd support
		EPATCH_OPTS="-p0 -d ${S}" epatch "${FILESDIR}/nss_ldap-265-fbsd.patch"
	fi

	eautoreconf
}

multilib_src_configure() {
	local myconf=()
	use debug && myconf+=( --enable-debugging )
	use kerberos && myconf+=( --enable-configurable-krb5-ccname-gssapi )
	multilib_is_native_abi && myconf+=( --libdir="${EPREFIX}/$(get_libdir)" )
	# --enable-schema-mapping \
	ECONF_SOURCE=${S} \
	econf \
		--with-ldap-lib=openldap \
		--with-ldap-conf-file="${EPREFIX}/etc/ldap.conf" \
		--enable-paged-results \
		--enable-rfc2307bis \
		$(use_enable ssl) \
		$(use_enable sasl) \
		$(use_enable kerberos krb) \
		"${myconf[@]}"

	if use kernel_FreeBSD; then
		# configure.in does not properly handle include dependencies
		echo "#define HAVE_NETINET_IF_ETHER_H 1" >> ${S}/config.h
		echo "#define HAVE_NET_ROUTE_H 1" >> ${S}/config.h
		echo "#define HAVE_RESOLV_H 1" >> ${S}/config.h
	fi
}

multilib_src_install() {
	if use kernel_FreeBSD; then
		emake -j1 DESTDIR="${D}" install
	else
		emake -j1 DESTDIR="${D}" install \
			INST_UID=${PORTAGE_USER:-root} INST_GID=${PORTAGE_GROUP:-root}
	fi
}

multilib_src_install_all() {
	# dumb /usr/lib* -> /lib* symlinks gone wrong
	rm -rf "${ED}"/usr/usr

	insinto /etc
	doins ldap.conf

	# Append two blank lines and some skip entries
	echo >>"${ED}"/etc/ldap.conf
	echo >>"${ED}"/etc/ldap.conf
	sed -i "${ED}"/etc/ldap.conf \
		-e '$inss_initgroups_ignoreusers ldap,openldap,mysql,syslog,root,postgres'

	dodoc ldap.conf ANNOUNCE NEWS ChangeLog AUTHORS \
		CVSVersionInfo.txt README nsswitch.ldap certutil
	docinto docs; dodoc doc/*
}

pkg_postinst() {
	elog "If you use a ldaps:// string in the 'uri' setting of"
	elog "your /etc/ldap.conf, you must set 'ssl on'!"
}
