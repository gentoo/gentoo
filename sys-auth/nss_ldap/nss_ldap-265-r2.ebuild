# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/nss_ldap/nss_ldap-265-r2.ebuild,v 1.10 2014/06/18 13:06:26 klausman Exp $

EAPI=5
inherit fixheadtails eutils multilib autotools prefix

IUSE="debug ssl sasl kerberos"

DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/nss_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux"

DEPEND=">=net-nds/openldap-2.1.30-r5
		sasl? ( dev-libs/cyrus-sasl )
		kerberos? ( virtual/krb5 )
		ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
		!<net-fs/autofs-4.1.3"

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

	sed -i \
		-e 's, vers_string , ./vers_string ,g' \
		"${S}"/Makefile.am

	eautoreconf
}

src_configure() {
	local myconf=""
	use debug && myconf="${myconf} --enable-debugging"
	use kerberos && myconf="${myconf} --enable-configurable-krb5-ccname-gssapi"
	# --enable-schema-mapping \
	econf \
		--with-ldap-lib=openldap \
		--libdir="${EPREFIX}/$(get_libdir)" \
		--with-ldap-conf-file="${EPREFIX}/etc/ldap.conf" \
		--enable-paged-results \
		--enable-rfc2307bis \
		$(use_enable ssl) \
		$(use_enable sasl) \
		$(use_enable kerberos krb) \
		${myconf}
}

src_install() {
	dodir /$(get_libdir)

	emake -j1 DESTDIR="${D}" install \
		INST_UID=${PORTAGE_USER:-root} INST_GID=${PORTAGE_GROUP:-root}

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
