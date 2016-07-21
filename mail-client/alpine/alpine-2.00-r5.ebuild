# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic autotools multilib toolchain-funcs

CHAPPA_PL=115
DESCRIPTION="alpine is an easy to use text-based based mail and news client"
HOMEPAGE="http://www.washington.edu/alpine/ http://patches.freeiz.com/alpine/"
SRC_URI="ftp://ftp.cac.washington.edu/alpine/${P}.tar.bz2
	chappa? ( http://patches.freeiz.com/alpine/patches/alpine-2.00/all.patch.gz
	-> ${P}-chappa-${CHAPPA_PL}-all.patch.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="doc ipv6 kerberos ldap nls onlyalpine passfile smime spell ssl threads topal +chappa"

DEPEND="virtual/pam
	>=net-libs/c-client-2007f-r4[topal=,chappa=]
	>=sys-libs/ncurses-5.1
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap )
	kerberos? ( app-crypt/mit-krb5 )
	spell? ( app-text/aspell )
	topal? ( >=net-mail/topal-72 )"
RDEPEND="${DEPEND}
	app-misc/mime-types
	!onlyalpine? ( !mail-client/pine )
	!<=net-mail/uw-imap-2004g"

pkg_setup() {
	if use smime && use topal ; then
		ewarn "You can not have USE='smime topal'. Assuming topal is more important."
	fi
}

src_prepare() {
	use chappa && epatch "${DISTDIR}/${P}-chappa-${CHAPPA_PL}-all.patch.gz"
	use topal && epatch /usr/share/topal/patches/"${P}".patch-{1,2}

	# do not use the bundled c-client
	ebegin "Unbundling the c-client library"
	rm -rf "${S}"/imap
	local f
	while read f ; do
	sed -i -e \
		's~^#include[[:blank:]]".*/c-client/\(.*\)"~#include <imap/\1>~g' "$f"
	done < <(find "${S}" -name "*.c" -o -name "*.h")
	eend $?

	epatch "${FILESDIR}"/2.00-lpam.patch
	epatch "${FILESDIR}"/2.00-lcrypto.patch
	epatch "${FILESDIR}"/2.00-c-client.patch
	epatch "${FILESDIR}"/2.00-qa.patch
	use chappa && epatch "${FILESDIR}/2.00-qa-chappa-${CHAPPA_PL}.patch"

	eautoreconf
}

src_configure() {
	local myconf="--without-tcl
		--with-system-pinerc=/etc/pine.conf
		--with-system-fixed-pinerc=/etc/pine.conf.fixed"
		#--disable-debug"
		# fixme
		#   --with-system-mail-directory=DIR?

	if use ssl; then
		myconf+=" --with-ssl
			--with-ssl-include-dir=/usr
			--with-ssl-lib-dir=/usr/$(get_libdir)
			--with-ssl-certs-dir=/etc/ssl/certs"
	else
		myconf+="--without-ssl"
	fi
	econf \
		$(use_with ldap) \
		$(use_with passfile passfile .pinepwd) \
		$(use_with kerberos krb5) \
		$(use_with threads pthread) \
		$(use_with spell interactive-spellcheck /usr/bin/aspell) \
		$(use_enable nls) \
		$(use_with ipv6) \
		$(use topal || use_with smime) \
		${myconf}
}

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	if use onlyalpine ; then
		dobin alpine/alpine
		doman doc/alpine.1
	else
		emake DESTDIR="${D}" install
		doman doc/rpdump.1 doc/rpload.1
	fi

	dodoc NOTICE README*

	if use doc ; then
		dodoc doc/brochure.txt doc/tech-notes.txt

		docinto html/tech-notes
		dohtml -r doc/tech-notes/
	fi
}
