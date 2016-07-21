# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools db-use eutils multilib toolchain-funcs

MY_PV="${PV/_/}"

DESCRIPTION="Developer support for the Cyrus IMAP Server"
HOMEPAGE="http://www.cyrusimap.org/"
SRC_URI="ftp://ftp.cyrusimap.org/cyrus-imapd/cyrus-imapd-${MY_PV}.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"
IUSE="afs berkdb kerberos snmp ssl tcpd"

RDEPEND=">=dev-libs/cyrus-sasl-2.1.13
	afs? ( net-fs/openafs )
	berkdb? ( >=sys-libs/db-3.2 )
	kerberos? ( virtual/krb5 )
	snmp? ( net-analyzer/net-snmp )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	!net-mail/cyrus-imapd"

DEPEND="${RDEPEND}"

S="${WORKDIR}/cyrus-imapd-${MY_PV}"

src_prepare() {
	sed -i -e "s/ar cr/$(tc-getAR) cr/" \
		perl/sieve/lib/Makefile.in \
		imap/Makefile.in \
		lib/Makefile.in \
		installsieve/Makefile.in \
		com_err/et/Makefile.in \
		sieve/Makefile.in \
		syslog/Makefile.in

	eautoreconf
}

src_configure() {
	local myconf
	if use afs ; then
		myconf=" --with-afs-libdir=/usr/$(get_libdir)"
		myconf+=" --with-afs-incdir=/usr/include/afs"
	fi
	if use berkdb ; then
		myconf+="--with-bdb-incdir=$(db_includedir)"
	fi

	econf \
		--enable-murder \
		--enable-netscapehack \
		--enable-idled \
		--with-cyrus-group=mail \
		--with-com_err=yes \
		--without-perl \
		--without-krb \
		--without-krbdes \
		$(use_enable afs) \
		$(use_enable afs krb5afspts) \
		$(use_with berkdb bdb) \
		$(use_with ssl openssl) \
		$(use_with snmp) \
		$(use_with tcpd libwrap) \
		$(use_enable kerberos gssapi) \
		${myconf}
}

src_compile() {
	emake -C "${S}/lib" all
}

src_install() {
	dodir /usr/include/cyrus

	emake -C "${S}/lib" DESTDIR="${D}" install
	dodoc README*
}
