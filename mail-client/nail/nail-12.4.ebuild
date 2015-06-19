# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/nail/nail-12.4.ebuild,v 1.17 2011/10/12 17:21:54 armin76 Exp $

EAPI="3"

inherit eutils toolchain-funcs

HOMEPAGE="http://heirloom.sourceforge.net/"
DESCRIPTION="an enhanced mailx-compatible mail client"
LICENSE="BSD"

MY_PN="mailx"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://sourceforge/project/heirloom/heirloom-${MY_PN}/${PV}/${MY_P}.tar.bz2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-freebsd ~x86-interix"
IUSE="ssl net kerberos"

RDEPEND="
	ssl? ( dev-libs/openssl )
	kerberos? ( virtual/krb5 )
	!mail-client/mailx
	!net-mail/mailutils
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

remove_ssl() {
	elog "Disabling SSL support"
	sed -i -e 's~#define USE_\(OPEN\)\?SSL~#undef USE_\1SSL~' config.h
	sed -i -e 's~-ssl~~' -e 's~-lcrypto~~' LIBS
}

remove_sockets() {
	elog "Not enabling sockets (thus disabling IMAP, POP and SMTP)"
	sed -i -e 's~#define HAVE_SOCKETS~#undef HAVE_SOCKETS~' config.h
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-debian.patch \
		"${FILESDIR}"/${P}-openssl-1.patch
	# Do not strip the binary
	sed -i -e '/STRIP/d' Makefile
}

src_configure() {
	# Build config.h and LIBS, neccesary to tweak the config
	make config.h LIBS

	# Logic to 'configure' the package
	if use net && ! use ssl ; then
		remove_ssl
	elif ! use net ; then
		# Linking to ssl without net support is pointless
		remove_ssl
		remove_sockets
	fi
}

src_compile() {
	# No configure script to check for and set this
	tc-export CC

	emake \
		CPPFLAGS="${CPPFLAGS} -D_GNU_SOURCE"
		PREFIX="${EPREFIX}"/usr SYSCONFDIR="${EPREFIX}"/etc \
		MAILSPOOL='/var/spool/mail' \
		|| die "emake failed"
}

src_install () {
	# Use /usr/lib/sendmail by default and provide an example
	cat <<- EOSMTP >> nail.rc

		# Use the local sendmail (/usr/lib/sendmail) binary by default.
		# (Uncomment the following line to use a SMTP server)
		#set smtp=localhost
	EOSMTP

	make DESTDIR="${D}" \
		UCBINSTALL=$(type -p install) \
		PREFIX="${EPREFIX}"/usr SYSCONFDIR="${EPREFIX}"/etc install \
		|| die
	dodoc AUTHORS README
	dodir /bin
	dosym /usr/bin/mailx /bin/mail
	dosym /usr/bin/mailx /usr/bin/mail
	dosym /usr/bin/mailx /usr/bin/Mail
}
