# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic

SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="A small but very powerful text-based mail client"
HOMEPAGE="https://www.neomutt.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="berkdb crypt debug doc gdbm gnutls gpg idn kerberos kyotocabinet
	libressl lmdb nls notmuch qdbm sasl selinux slang smime ssl +symlink
	tokyocabinet"

CDEPEND="
	app-misc/mime-types
	berkdb? ( >=sys-libs/db-4:= )
	gdbm? ( sys-libs/gdbm )
	kyotocabinet? ( dev-db/kyotocabinet )
	lmdb? ( dev-db/lmdb )
	nls? ( virtual/libintl )
	qdbm? ( dev-db/qdbm )
	tokyocabinet? ( dev-db/tokyocabinet )
	gnutls? ( >=net-libs/gnutls-1.0.17 )
	gpg? ( >=app-crypt/gpgme-0.9.0 )
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

src_prepare() {
	eapply "${FILESDIR}/0001-Rename-mutt-to-neomutt-${PV}.patch"
	eapply_user
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	local myconf=(
		"$(use_enable crypt pgp)"
		"$(use_enable debug)"
		"$(use_enable doc)"
		"$(use_enable gpg gpgme)"
		"$(use_enable nls)"
		"$(use_enable smime)"
		"$(use_enable notmuch)"
		"$(use_with idn)"
		"$(use_with kerberos gss)"
		"$(use_with sasl)"
		"$(use_with tokyocabinet)"
		"$(use_with kyotocabinet)"
		"$(use_with qdbm)"
		"$(use_with gdbm)"
		"$(use_with berkdb bdb)"
		"$(use_with lmdb)"
		"--with-$(usex slang slang curses)"
		"--sysconfdir=${EPREFIX}/etc/${PN}"
		"--with-docdir=${EPREFIX}/usr/share/doc/${PF}"
	)

	if use gnutls; then
		myconf+=( "--with-gnutls" )
	elif use ssl; then
		myconf+=( "--with-ssl" )
	fi

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	# A newer file is provided by app-misc/mime-types. So we link it.
	rm "${ED}"/etc/${PN}/mime.types || die
	dosym "${EPREFIX}/etc/mime.types" /etc/${PN}/mime.types

	## A man-page is always handy, so fake one
	if use !doc; then
		emake -C doc neomuttrc.man
		# make the fake slightly better, bug #413405
		sed -e 's#@docdir@/manual.txt#http://www.neomutt.org/guide#' \
			-e 's#in @docdir@,#at http://www.neomutt.org/,#' \
			-e "s#@sysconfdir@#${EPREFIX}/etc/${PN}#" \
			-e "s#@bindir@#${EPREFIX}/usr/bin#" \
			doc/mutt.man > neomutt.1 || die
		cp doc/neomuttrc.man neomuttrc.5 || die
		doman neomutt.1 neomuttrc.5
	fi

	dodoc COPYRIGHT ChangeLog* OPS* README*
}
