# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools db-use eutils perl-app toolchain-funcs

MY_PV=${PV/_/}

DESCRIPTION="Utilities and Perl modules to administer a Cyrus IMAP server"
HOMEPAGE="http://www.cyrusimap.org/"
SRC_URI="ftp://ftp.cyrusimap.org/cyrus-imapd/cyrus-imapd-${MY_PV}.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="berkdb kerberos libressl ssl"

RDEPEND=">=dev-lang/perl-5.6.1
	>=dev-libs/cyrus-sasl-2.1.13
	dev-perl/Term-ReadLine-Perl
	dev-perl/TermReadKey
	berkdb? ( >=sys-libs/db-3.2:* )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	kerberos? ( virtual/krb5 )"

DEPEND="$RDEPEND"

S="${WORKDIR}/cyrus-imapd-${MY_PV}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4.10-ldflags.patch"
	sed -i -e "s/ar cr/$(tc-getAR) cr/" \
		perl/sieve/lib/Makefile.in \
		imap/Makefile.in \
		lib/Makefile.in \
		installsieve/Makefile.in \
		com_err/et/Makefile.in \
		sieve/Makefile.in \
		syslog/Makefile.in
	AT_M4DIR="cmulocal" eautoreconf
}

src_configure() {
	local myconf
	if use berkdb ; then
		myconf="--with-bdb-incdir=$(db_includedir)"
	fi
	econf \
		--disable-server \
		--enable-murder \
		--enable-netscapehack \
		--with-cyrus-group=mail \
		--with-com_err=yes \
		--with-perl=/usr/bin/perl \
		--without-krb \
		--without-krbdes \
		$(use_with berkdb bdb) \
		$(use_enable kerberos gssapi) \
		$(use_with ssl openssl) \
		${myconf}
}

src_compile() {
	emake -C "${S}/lib" all
	emake -C "${S}/perl" all
}

src_install () {
	emake -C "${S}/perl" DESTDIR="${D}" INSTALLDIRS=vendor install
	perl_delete_localpod		# bug #98122
}
