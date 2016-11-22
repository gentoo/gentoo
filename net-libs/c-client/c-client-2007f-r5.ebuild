# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit flag-o-matic eutils libtool toolchain-funcs multilib

MY_PN=imap
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

CHAPPA_PL=115
DESCRIPTION="UW IMAP c-client library"
HOMEPAGE="http://www.washington.edu/imap/"
SRC_URI="ftp://ftp.cac.washington.edu/imap/${MY_P}.tar.Z
	chappa? ( mirror://gentoo/${P}-chappa-${CHAPPA_PL}-all.patch.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc +ipv6 kerberos kernel_linux kernel_FreeBSD libressl pam ssl static-libs topal chappa"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= ) )
	!net-mail/uw-imap
	kerberos? ( app-crypt/mit-krb5 )
"
DEPEND="${RDEPEND}
	kernel_linux? ( pam? ( >=sys-libs/pam-0.72 ) )
"

src_prepare() {
	default

	# Tarball packed with bad file perms
	chmod -R u+rwX,go-w .

	# lots of things need -fPIC, including various platforms, and this library
	# generally should be built with it anyway.
	append-flags -fPIC

	# Modifications so we can build it optimally and correctly
	sed \
		-e "s:BASECFLAGS=\".*\":BASECFLAGS=:g" \
		-e 's:SSLDIR=/usr/local/ssl:SSLDIR=/usr:g' \
		-e 's:SSLCERTS=$(SSLDIR)/certs:SSLCERTS=/etc/ssl/certs:g' \
		-i src/osdep/unix/Makefile || die "Makefile sed fixing failed"

	# Make the build system more multilib aware
	sed \
		-e "s:^SSLLIB=\$(SSLDIR)/lib:SSLLIB=\$(SSLDIR)/$(get_libdir):" \
		-e "s:^AFSLIB=\$(AFSDIR)/lib:AFSLIB=\$(AFSDIR)/$(get_libdir):" \
		-i src/osdep/unix/Makefile || die "Makefile sed fixing failed"

	# Targets should use the Gentoo (ie linux) fs
	sed -e '/^bsf:/,/^$/ s:ACTIVEFILE=.*:ACTIVEFILE=/var/lib/news/active:g' \
		-i src/osdep/unix/Makefile || die "Makefile sex fixing failed for FreeBSD"

	# Apply a patch to only build the stuff we need for c-client
	eapply "${FILESDIR}"/${PN}-2006k_GENTOO_Makefile.patch

	# Apply patch to add the compilation of a .so for PHP
	# This was previously conditional, but is more widely useful.
	eapply "${FILESDIR}"/${PN}-2006k_GENTOO_amd64-so-fix.patch

	# Remove the pesky checks about SSL stuff
	sed -e '/read.*exit/d' -i Makefile || die

	# Respect LDFLAGS
	eapply "${FILESDIR}"/${PN}-2007f-ldflags.patch
	sed -e "s/CC=cc/CC=$(tc-getCC)/" \
		-e "s/ARRC=ar/ARRC=$(tc-getAR)/" \
		-e "s/RANLIB=ranlib/RANLIB=$(tc-getRANLIB)/" \
		-i src/osdep/unix/Makefile || die "Respecting build flags"

	use topal && eapply "${FILESDIR}/${P}-topal.patch"
	use chappa && epatch "${DISTDIR}/${P}-chappa-${CHAPPA_PL}-all.patch.gz"

	elibtoolize
}

src_compile() {
	local mymake ipver ssltype target passwdtype
	ipver='IP=4'
	use ipv6 && ipver="IP=6" && touch ip6
	use ssl && ssltype="unix" || ssltype="none"
	if use kernel_linux ; then
		use pam && target=lnp passwdtype=pam || target=lnx passwdtype=std
	elif use kernel_FreeBSD ; then
		target=bsf passwdtype=pam
	fi
	use kerberos \
		&& mymake="EXTRAAUTHENTICATORS=gss" \
		&& EXTRALIBS="-lgssapi_krb5 -lkrb5 -lk5crypto -lcom_err" \
	# no parallel builds supported!
	emake -j1 SSLTYPE=${ssltype} $target \
		PASSWDTYPE=${passwdtype} ${ipver} ${mymake} \
		EXTRACFLAGS="${CFLAGS}" \
		EXTRALDFLAGS="${LDFLAGS}" \
		EXTRALIBS="${EXTRALIBS}" \
		GSSDIR=/usr
}

src_install() {
	if use static-libs; then
		# Library binary
		dolib.a c-client/c-client.a
		dosym c-client.a /usr/$(get_libdir)/libc-client.a
	fi

	# Now the shared library
	dolib.so c-client/libc-client.so.1.0.0

	dosym libc-client.so.1.0.0 /usr/$(get_libdir)/libc-client.so
	dosym libc-client.so.1.0.0 /usr/$(get_libdir)/libc-client.so.1

	# Headers
	insinto /usr/include/imap
	doins src/osdep/unix/*.h
	doins src/c-client/*.h
	doins c-client/linkage.h
	doins c-client/linkage.c
	doins c-client/osdep.h
	if use ssl; then
		echo "  ssl_onceonlyinit ();" >> "${D}"/usr/include/imap/linkage.c || die
	fi
	# Docs
	dodoc README docs/*.txt docs/BUILD docs/CONFIG docs/RELNOTES docs/SSLBUILD
	if use doc; then
		docinto rfc
		dodoc docs/rfc/*.txt
		docinto draft
		dodoc docs/draft/*
	fi
}
