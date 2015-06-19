# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/uw-imap/uw-imap-2007f-r1.ebuild,v 1.7 2014/08/10 20:47:17 slyfox Exp $

EAPI=4

inherit eutils flag-o-matic ssl-cert multilib

MY_P="imap-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="UW server daemons for IMAP and POP network mail protocols"
SRC_URI="ftp://ftp.cac.washington.edu/imap/${MY_P}.tar.Z"
HOMEPAGE="http://www.washington.edu/imap/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="ipv6 +ssl kerberos clearpasswd"

DEPEND="!net-libs/c-client
	>=sys-libs/pam-0.72
	>=net-mail/mailbase-0.00-r8[pam]
	ssl? ( dev-libs/openssl )
	kerberos? ( app-crypt/mit-krb5 )"

RDEPEND="${DEPEND}
	>=net-mail/uw-mailutils-${PV}
	sys-apps/xinetd"

# get rid of old style virtual - bug 350792
# all blockers really needed?
RDEPEND="${RDEPEND}
	!net-mail/dovecot
	!mail-mta/courier
	!net-mail/courier-imap
	!net-mail/cyrus-imapd"

REQUIRED_USE="!clearpasswd? ( ssl )"

src_unpack() {
	unpack ${A}
	# Tarball packed with bad file perms
	chmod -R ug+w "${S}"
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2004c-amd64-so-fix.patch
	epatch "${FILESDIR}/${PN}-ldflags.patch"

	# no interactive build
	sed -i -e "/read x; case/s/^/#/" Makefile || die
	sed -i -e "/make noip6/s/.*/\t@echo/" Makefile || die

	# Now we must make all the individual Makefiles use different CFLAGS,
	# otherwise they would all use -fPIC
	sed -i -e "s|\`cat \$C/CFLAGS\`|${CFLAGS}|g" src/dmail/Makefile \
		src/imapd/Makefile src/ipopd/Makefile src/mailutil/Makefile \
		src/mlock/Makefile src/mtest/Makefile src/tmail/Makefile \
		|| die "sed failed patching Makefile FLAGS."

	# Now there is only c-client left, which should be built with -fPIC
	append-flags -fPIC

	sed -i \
		-e "s:BASECFLAGS=\".*\":BASECFLAGS=:g" \
		-e 's,SSLDIR=/usr/local/ssl,SSLDIR=/usr,g' \
		-e 's,SSLCERTS=$(SSLDIR)/certs,SSLCERTS=/etc/ssl/certs,g' \
		src/osdep/unix/Makefile || die

	sed -i \
		-e "s/CC=cc/CC=$(tc-getCC)/" \
		-e "s/ARRC=ar/ARRC=$(tc-getAR)/" \
		-e "s/RANLIB=ranlib/RANLIB=$(tc-getRANLIB)/" \
		src/osdep/unix/Makefile || die

	sed -i -e "s,GSSDIR=/usr/local,GSSDIR=/usr,g" \
		src/osdep/unix/Makefile.gss || die

	# Make the build system more multilib aware
	sed \
		-e "s:^SSLLIB=\$(SSLDIR)/lib:SSLLIB=\$(SSLDIR)/$(get_libdir):" \
		-e "s:^AFSLIB=\$(AFSDIR)/lib:AFSLIB=\$(AFSDIR)/$(get_libdir):" \
		-i src/osdep/unix/Makefile || die "Makefile sed fixing failed"
}

src_compile() {
	local mymake ipver ssltype target
	ipver="IP=4"
	target=lnp
	use ipv6 && ipver="IP=6"
	use kerberos && mymake="EXTRAAUTHENTICATORS=gss"
	use kernel_FreeBSD && target=bsf
	if use ssl ; then
		if use clearpasswd ; then
			ssltype=unix
		else
			ssltype=unix.nopwd
		fi
	else
		ssltype=none
	fi

	emake -j1 SSLTYPE=${ssltype} ${target} ${mymake} ${ipver} EXTRACFLAGS="${CFLAGS}" EXTRALDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin imapd/imapd ipopd/ipop?d dmail/dmail tmail/tmail
	dobin mlock/mlock

	dolib.so c-client/libc-client.so.1.0.0
	dosym libc-client.so.1.0.0 /usr/$(get_libdir)/libc-client.so
	dosym libc-client.so.1.0.0 /usr/$(get_libdir)/libc-client.so.1

	insinto /usr/include/imap
	doins src/c-client/{c-client,flstring,mail,imap4r1,rfc822,misc,smtp,nntp,utf8,utf8aux}.h
	doins src/c-client/{env,fs,ftl,nl,tcp}.h
	doins src/osdep/unix/env_unix.h
	doins c-client/linkage.{c,h}

	dolib.a c-client/c-client.a
	dosym c-client.a /usr/$(get_libdir)/libc-client.a

	doman src/ipopd/ipopd.8 src/imapd/imapd.8
	doman src/dmail/dmail.1 src/tmail/tmail.1
	dodoc README docs/*.txt docs/CONFIG docs/RELNOTES

	docinto rfc
	dodoc docs/rfc/*.txt

	# install headers - bug #375393
	cp c-client/*.h "${D}"/usr/include/imap/ || die
	cp c-client/linkage.c "${D}"/usr/include/imap/ || die
	#exclude these dupes (can't do it before now due to symlink hell)
	rm "${D}"/usr/include/imap/os_*.h

	# gentoo config stuff
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/uw-imap.xinetd  imap
	newins "${FILESDIR}"/uw-ipop2.xinetd ipop2
	newins "${FILESDIR}"/uw-ipop3.xinetd ipop3
	newins "${FILESDIR}"/uw-ipop3s.xinetd ipop3s
	newins "${FILESDIR}"/uw-imaps.xinetd imaps
}

pkg_postinst() {
	if use ssl; then
	# Let's not make a new certificate if we already have one
		if ! [[ -e "${ROOT}"/etc/ssl/certs/imapd.pem && \
			-e "${ROOT}"/etc/ssl/certs/imapd.key ]]; then
			einfo "Creating SSL certificate for IMAP"
			SSL_ORGANIZATION="${SSL_ORGANIZATION:-UW-IMAP Server}"
			install_cert /etc/ssl/certs/imapd
		fi
		if ! [[ -e "${ROOT}"/etc/ssl/certs/ipop3d.pem && \
			-e "${ROOT}"/etc/ssl/certs/ipop3d.key ]]; then
			einfo "Creating SSL certificate for POP3"
			SSL_ORGANIZATION="${SSL_ORGANIZATION:-UW-POP3 Server}"
			install_cert /etc/ssl/certs/ipop3d
		fi
	fi
}
