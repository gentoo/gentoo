# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic

if [[ ${PV} =~ 9999$ ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/neomutt/neomutt.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/neomutt-${P}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A small but very powerful text-based mail client"
HOMEPAGE="https://www.neomutt.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="berkdb crypt doc gdbm gnutls gpg gpgme idn kerberos kyotocabinet
	libressl lmdb nls notmuch pgp_classic qdbm sasl selinux slang smime
	smime_classic ssl tokyocabinet"

CDEPEND="
	app-misc/mime-types
	berkdb? (
		|| (
			sys-libs/db:6.2
			sys-libs/db:5.3
			sys-libs/db:4.8
		)
		<sys-libs/db-6.3:=
	)
	gdbm? ( sys-libs/gdbm )
	kyotocabinet? ( dev-db/kyotocabinet )
	lmdb? ( dev-db/lmdb )
	nls? ( virtual/libintl )
	qdbm? ( dev-db/qdbm )
	tokyocabinet? ( dev-db/tokyocabinet )
	gnutls? ( >=net-libs/gnutls-1.0.17 )
	gpg? ( >=app-crypt/gpgme-0.9.0 )
	gpgme? ( >=app-crypt/gpgme-0.9.0 )
	idn? ( net-dns/libidn )
	kerberos? ( virtual/krb5 )
	notmuch? ( net-mail/notmuch )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	!slang? ( sys-libs/ncurses:0 )
	slang? ( sys-libs/slang )
	ssl? (
		!libressl? ( >=dev-libs/openssl-0.9.6:0 )
		libressl? ( dev-libs/libressl )
	)
"
DEPEND="${CDEPEND}
	dev-lang/tcl
	net-mail/mailbase
	doc? (
		dev-libs/libxml2
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
		|| ( www-client/lynx www-client/w3m www-client/elinks )
	)"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-mutt )
"

S="${WORKDIR}/${PN}-${P}"

src_configure() {
	local myconf=(
		"$(use_enable doc)"
		"$(use_enable nls)"
		"$(use_enable notmuch)"

		# During the transition of the crypto USE flags we need to support
		# both sets of flags. We do not want to emit a configuration setting
		# twice, since the second flag overrides the first, potentially
		# leading to unwanted settings. See https://bugs.gentoo.org/640824 for
		# details.
		"$(if use gpg || use gpgme; then echo "--enable"; else echo "--disable"; fi)-gpgme"
		"$(if use crypt || use pgp_classic; then echo "--enable"; else echo "--disable"; fi)-pgp"
		"$(if use smime || use smime_classic; then echo "--enable"; else echo "--disable"; fi)-smime"

		# Database backends.
		"$(use_enable berkdb bdb)"
		"$(use_enable gdbm)"
		"$(use_enable kyotocabinet)"
		"$(use_enable qdbm)"
		"$(use_enable tokyocabinet)"

		"$(use_enable idn)"
		"$(use_enable kerberos gss)"
		"$(use_enable lmdb)"
		"$(use_enable sasl)"
		"--with-ui=$(usex slang slang ncurses)"
		"--sysconfdir=${EPREFIX}/etc/${PN}"
		"$(use_enable ssl)"
		"$(use_enable gnutls)"
	)

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	# A man-page is always handy, so fake one – here neomuttrc.5
	# (neomutt.1 already exists)
	if use !doc; then
		sed -n '/^\(SRCDIR\|EXEEXT\|CC_FOR_BUILD\)\s*=/p;$a\\n' \
			Makefile > doc/Makefile.fakedoc || die
		sed -n '/^\(MAKEDOC_CPP\s*=\|doc\/\(makedoc$(EXEEXT)\|neomuttrc.man\):\)/,/^[[:blank:]]*$/p' \
			doc/Makefile.autosetup >> doc/Makefile.fakedoc || die
		emake -f doc/Makefile.fakedoc doc/neomuttrc.man
		cp doc/neomuttrc.man doc/neomuttrc.5 || die
		doman doc/neomutt.1 doc/neomuttrc.5
	fi

	dodoc COPYRIGHT LICENSE* ChangeLog* README*
}

pkg_postinst() {
	if use crypt || use gpg || use smime; then
		ewarn "Pleae note that the crypto related USE flags of neomutt have changed."
		ewarn "(https://bugs.gentoo.org/637176)"
		ewarn "crypt -> pgp_classic"
		ewarn "gpg -> gpgme"
		ewarn "smime -> smime_classic"
		ewarn "The old USE flags still work but their use is deprecated and will"
		ewarn "be removed in a future release."
		if use gpg && ( use crypt || use smime ); then
			ewarn "  Note that gpgme (old gpg) includes both pgp and smime"
			ewarn "  support.  You can probably remove pgp_classic (old crypt)"
			ewarn "  and smime_classic (old smime) from your USE-flags and"
			ewarn "  only enable gpgme."
		fi
	fi
}
