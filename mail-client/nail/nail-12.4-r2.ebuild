# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils toolchain-funcs

HOMEPAGE="http://heirloom.sourceforge.net/"
DESCRIPTION="an enhanced mailx-compatible mail client"
LICENSE="BSD"

MY_PN="mailx"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://sourceforge/project/heirloom/heirloom-${MY_PN}/${PV}/${MY_P}.tar.bz2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ssl net kerberos"

RDEPEND="
	net? (
		ssl? ( dev-libs/openssl )
		kerberos? ( virtual/krb5 )
	)
	!mail-client/mailx
	!net-mail/mailutils
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

undef() {
	sed -i -e "/$1/s:#define:#undef:" config.h || die
}

droplib() {
	sed -i -e "/$1/s:^:#:" LIBS || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-debian.patch \
		"${FILESDIR}"/${P}-openssl-1.patch
	# Do not strip the binary
	sed -i -e '/STRIP/d' Makefile
}

src_configure() {
	# Build config.h and LIBS, neccesary to tweak the config
	# use -j1 because it will produce bogus output otherwise
	emake -j1 config.h LIBS || die

	# Logic to 'configure' the package

	if ! use ssl || ! use net ; then
		undef 'USE_\(OPEN\)\?SSL'
		droplib -lssl
	fi

	if ! use kerberos || ! use net ; then
		undef 'USE_GSSAPI'
		droplib -lgssapi_krb5
	fi

	if ! use net ; then
		undef 'HAVE_SOCKETS'
	fi
}

src_compile() {
	# No configure script to check for and set this
	tc-export CC

	emake \
		CPPFLAGS="${CPPFLAGS} -D_GNU_SOURCE" \
		PREFIX="${EPREFIX}"/usr SYSCONFDIR="${EPREFIX}"/etc \
		SENDMAIL="${EPREFIX}/usr/sbin/sendmail" \
		MAILSPOOL='/var/spool/mail' \
		|| die "emake failed"
}

src_install () {
	# Use /usr/sbin/sendmail by default and provide an example
	cat <<- EOSMTP >> nail.rc

		# Use the local sendmail (/usr/sbin/sendmail) binary by default.
		# (Uncomment the following line to use a SMTP server)
		#set smtp=localhost

		# Ask for CC: list too.
		set askcc
	EOSMTP

	emake DESTDIR="${D}" \
		UCBINSTALL=$(type -p install) \
		PREFIX="${EPREFIX}"/usr SYSCONFDIR="${EPREFIX}"/etc install \
		|| die

	dodoc AUTHORS README || die

	dodir /bin
	dosym ../usr/bin/mailx /bin/mail || die
	dosym mailx /usr/bin/mail || die
	dosym mailx /usr/bin/Mail || die

	dosym mailx.1 /usr/share/man/man1/mail.1 || die
	dosym mailx.1 /usr/share/man/man1/Mail.1 || die
}
