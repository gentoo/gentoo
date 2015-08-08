# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit fixheadtails eutils multilib autotools

IUSE="debug ssl sasl kerberos"

DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/nss_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"

DEPEND=">=net-nds/openldap-2.1.30-r5
		sasl? ( dev-libs/cyrus-sasl )
		kerberos? ( virtual/krb5 )
		ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
		!<net-fs/autofs-4.1.3"

src_prepare() {
	epatch "${FILESDIR}"/nsswitch.ldap.diff

	# Applied by upstream
	#epatch "${FILESDIR}"/${PN}-239-tls-security-bug.patch

	epatch "${FILESDIR}"/${PN}-249-sasl-compile.patch

	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${PN}-252-reconnect-timeouts.patch

	# Applied by upstream
	#EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${PN}-254-nss_getgrent_skipmembers.patch

	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${PN}-257-nss_max_group_depth.patch

	sed -i.orig \
		-e '/^ @(#)\$Id: ldap.conf,v/s,^,#,' \
		"${S}"/ldap.conf || die "failed to clean up initial version marker"

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

	eautoreconf
}

src_configure() {
	local myconf=""
	use debug && myconf="${myconf} --enable-debugging"
	use kerberos && myconf="${myconf} --enable-configurable-krb5-ccname-gssapi"
	# --enable-schema-mapping \
	econf \
		--with-ldap-lib=openldap \
		--libdir=/$(get_libdir) \
		--enable-paged-results \
		--enable-rfc2307bis \
		$(use_enable ssl) \
		$(use_enable sasl) \
		$(use_enable kerberos krb) \
		${myconf} || die "configure failed"
}

src_install() {
	dodir /$(get_libdir)

	emake -j1 DESTDIR="${D}" install || die "make install failed"

	insinto /etc
	doins ldap.conf

	dodoc ldap.conf ANNOUNCE NEWS ChangeLog AUTHORS \
		COPYING CVSVersionInfo.txt README nsswitch.ldap certutil
	docinto docs; dodoc doc/*
}

pkg_postinst() {
	elog "If you use a ldaps:// string in the 'uri' setting of"
	elog "your /etc/ldap.conf, you must set 'ssl on'!"
}
