# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools toolchain-funcs

DESCRIPTION="An easy to use text-based based mail and news client"
HOMEPAGE="http://www.washington.edu/alpine/ http://repo.or.cz/alpine.git/"
GIT_COMMIT="843b2f16abfd949e09b1c5465387b1b0f724994a"
MY_P="${PN}-${GIT_COMMIT::7}"
SRC_URI="http://repo.or.cz/alpine.git/snapshot/${GIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="doc ipv6 kerberos ldap libressl nls onlyalpine passfile smime spell ssl threads"

DEPEND="virtual/pam
	>=sys-libs/ncurses-5.1:0=
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	ldap? ( net-nds/openldap )
	kerberos? ( app-crypt/mit-krb5 )
	spell? ( app-text/aspell )
"
RDEPEND="${DEPEND}
	app-misc/mime-types
	!onlyalpine? ( !mail-client/pine )
	!<=net-mail/uw-imap-2004g
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	myconf=(
		--without-tcl
		--with-system-pinerc="${EPREFIX}"/etc/pine.conf
		--with-system-fixed-pinerc="${EPREFIX}"/etc/pine.conf.fixed
	)

	if use ssl; then
		myconf+=(
			--with-ssl-include-dir="${EPREFIX}"/usr/include/openssl
			--with-ssl-lib-dir="${EPREFIX}"/usr/$(get_libdir)
			--with-ssl-certs-dir="${EPREFIX}"/etc/ssl/certs
		)
	fi
	econf \
		$(use_with ldap) \
		$(use_with ssl) \
		$(use_with passfile passfile .pinepwd) \
		$(use_with kerberos krb5) \
		$(use_with threads pthread) \
		$(use_with spell interactive-spellcheck /usr/bin/aspell) \
		$(use_enable nls) \
		$(use_with ipv6) \
		$(use_with smime) \
		"${myconf[@]}"
}

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	if use onlyalpine ; then
		dobin alpine/alpine
		doman doc/man1/alpine.1
	else
		emake DESTDIR="${D}" install
		doman doc/man1/*.1
	fi

	dodoc NOTICE README*

	if use doc ; then
		dodoc doc/brochure.txt

		dodoc doc/tech-notes/tech-notes.txt
		newdoc "${S}/doc/mailcap.unx" mailcap.unx.sample
		newdoc "${S}/doc/mime.types" mime.types.sample
		docinto html/tech-notes
		dohtml -r doc/tech-notes/
		docompress -x /usr/share/doc/${PF}/mailcap.unx.sample /usr/share/doc/${PF}/mime.types.sample
	fi
}
