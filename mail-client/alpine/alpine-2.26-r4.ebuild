# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic optfeature toolchain-funcs

DESCRIPTION="An easy to use text-based based mail and news client"
HOMEPAGE="https://alpineapp.email/ https://repo.or.cz/alpine.git/"
CHAPPA_PATCH_NAME="${P}-chappa-5.patch"
SRC_URI="https://alpineapp.email/alpine/release/src/${P}.tar.xz
	chappa? ( https://alpineapp.email/alpine/patches/${P}/all.patch.gz -> ${CHAPPA_PATCH_NAME}.gz ) "

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+chappa ipv6 kerberos ldap nls onlyalpine passfile smime ssl"

DEPEND="sys-libs/ncurses:=
	virtual/libcrypt:=
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap:= )
	ssl? ( dev-libs/openssl:0= )
"
RDEPEND="${DEPEND}
	app-misc/mime-types
"

src_prepare() {
	default
	use chappa && eapply "${WORKDIR}/${CHAPPA_PATCH_NAME}"
	if use chappa; then
		eapply "${FILESDIR}/${PN}-2.26-fix-clang16-build.patch"
	else
		eapply "${FILESDIR}/${PN}-2.26-fix-clang16-build-no-chappa.patch"
	fi
	eautoreconf
	tc-export CC RANLIB AR
	export CC_FOR_BUILD="$(tc-getBUILD_CC)"
}

src_configure() {
	myconf=(
		--without-tcl
		--with-pthread
		--with-system-pinerc="${EPREFIX}"/etc/pine.conf
		--with-system-fixed-pinerc="${EPREFIX}"/etc/pine.conf.fixed
		$(use_with ldap)
		$(use_with ssl)
		$(use_with passfile passfile .pinepwd)
		$(use_with kerberos krb5)
		$(use_enable nls)
		$(use_with ipv6)
		$(use_with smime)
	)

	if has_version "app-text/hunspell"; then
		myconf+=( --with-interactive-spellcheck=/usr/bin/hunspell )
	elif has_version "app-text/aspell"; then
		myconf+=( --with-interactive-spellcheck=/usr/bin/aspell )
	fi

	if use ssl; then
		myconf+=(
			--with-ssl-include-dir="${EPREFIX}"/usr/include/openssl
			--with-ssl-lib-dir="${EPREFIX}"/usr/$(get_libdir)
			--with-ssl-certs-dir="${EPREFIX}"/etc/ssl/certs
		)
	fi

	# Bug 935343; see imap/docs/bugs.txt
	if use ipv6; then
		sed -i "s/IP=4/IP=6/" imap/Makefile || die
	fi

	# problems with strict prototypes, not easily patched #870766
	append-cflags -Wno-error=strict-prototypes

	# problems with incompatible pointer types, not easily patched #920365
	append-cflags -Wno-error=incompatible-pointer-types

	econf "${myconf[@]}"
}

src_compile() {
	# the bundled c-client lib stumbles with both -j>1 and --shuffle #888709
	emake -j1 --shuffle=none AR="$(tc-getAR)" c-client
	emake AR="$(tc-getAR)"
}

src_install() {
	if use onlyalpine ; then
		dobin alpine/alpine
		doman doc/man1/alpine.1
	else
		emake -j1 DESTDIR="${D}" install
		doman doc/man1/*.1
	fi
	dodoc NOTICE README*
	dodoc doc/brochure.txt
	dodoc -r doc/tech-notes/
	newdoc "${S}/doc/mailcap.unx" mailcap.unx.sample
	newdoc "${S}/doc/mime.types" mime.types.sample
	docompress -x /usr/share/doc/${PF}/mailcap.unx.sample /usr/share/doc/${PF}/mime.types.sample
}

pkg_postinst() {
	optfeature "Spell checking" app-text/hunspell app-text/aspell
}
