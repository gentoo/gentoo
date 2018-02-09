# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils flag-o-matic autotools

PATCHREV="r0"
PATCHSET="gentoo-${PVR}/${PATCHREV}"

DESCRIPTION="A small but very powerful text-based mail client"
HOMEPAGE="http://www.mutt.org/"
MUTT_G_PATCHES="mutt-gentoo-${PV}-patches-${PATCHREV}.tar.xz"
SRC_URI="ftp://ftp.mutt.org/pub/mutt/${P}.tar.gz
	https://bitbucket.org/${PN}/${PN}/downloads/${P}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/${MUTT_G_PATCHES}"
IUSE="berkdb crypt debug doc gdbm gnutls gpg gpgme +hcache idn +imap kerberos libressl +lmdb mbox nls nntp notmuch pgp_classic pop qdbm +sasl selinux slang smime smime_classic +smtp +ssl tokyocabinet vanilla prefix"
REQUIRED_USE="
	hcache?           ( ^^ ( berkdb gdbm lmdb qdbm tokyocabinet ) )
	imap?             ( ssl )
	pop?              ( ssl )
	nntp?             ( ssl )
	smime?            ( ssl !gnutls )
	smime_classic?    ( ssl !gnutls )
	smtp?             ( ssl )
	sasl?             ( || ( imap pop smtp nntp ) )
	kerberos?         ( || ( imap pop smtp nntp ) )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
CDEPEND="
	app-misc/mime-types

	berkdb?        ( >=sys-libs/db-4:= )
	gdbm?          ( sys-libs/gdbm )
	lmdb?          ( dev-db/lmdb:= )
	qdbm?          ( dev-db/qdbm )
	tokyocabinet?  ( dev-db/tokyocabinet )

	ssl? (
		gnutls?    ( >=net-libs/gnutls-1.0.17:= )
		!gnutls? (
			libressl? ( dev-libs/libressl:= )
			!libressl? ( >=dev-libs/openssl-0.9.6:0= )
		)
	)

	nls?           ( virtual/libintl )
	sasl?          ( >=dev-libs/cyrus-sasl-2 )
	kerberos?      ( virtual/krb5 )
	idn?           ( net-dns/libidn )
	gpg?           ( >=app-crypt/gpgme-0.9.0:= )
	gpgme?         ( >=app-crypt/gpgme-0.9.0:= )
	notmuch?       ( net-mail/notmuch:= )
	slang?         ( sys-libs/slang )
	!slang?        ( >=sys-libs/ncurses-5.2:0= )
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
	smime? ( || ( dev-libs/libressl >=dev-libs/openssl-0.9.6:0 ) )
	smime_classic? ( || ( dev-libs/libressl >=dev-libs/openssl-0.9.6:0 ) )
	crypt? ( app-crypt/gnupg )
	pgp_classic? ( app-crypt/gnupg )
"

src_prepare() {
	local PATCHDIR="${WORKDIR}"/mutt-gentoo-${PV}-patches

	if use !vanilla ; then
		# apply patches
		export EPATCH_FORCE="yes"
		export EPATCH_SUFFIX="patch"
		# http://hg.code.sf.net/p/gentoomuttpatches/code/file/mutt-1.9
		local patches=(
			patches-mutt
			bugs-gentoo
			features-common
			features-extra
			gentoo
		)
		local patchset
		for patchset in "${patches[@]}" ; do
			[[ -d "${PATCHDIR}/${patchset}" ]] || continue
			einfo "Patches for ${PATCHSET} patchset ${patchset}"
			EPATCH_SOURCE="${PATCHDIR}"/${patchset} epatch \
				|| die "patchset ${patchset} failed"
		done
		# add some explanation as to why not to go upstream
		sed -i \
			-e '/ReachingUs = N_(/aThis release of Mutt is heavily enriched with patches.\\nFor this reason, any bugs are better reported at https://bugs.gentoo.org/\\nor re-emerge with USE=vanilla and try to reproduce your problem.\\n\\' \
			main.c || die "Failed to add bug instructions"
	fi

	local upatches=
	# allow user patches
	eapply_user && upatches=" with user patches"

	# patch version string for bug reports
	local patchset=
	use vanilla || patchset=", ${PATCHSET}"
	sed -i -e 's|"Mutt %s (%s)"|"Mutt %s (%s'"${patchset}${upatches}"')"|' \
		muttlib.c || die "failed patching in Gentoo version"

	# many patches touch the buildsystem, we always need this
	AT_M4DIR="m4" eautoreconf

	# the configure script contains some "cleverness" whether or not to setgid
	# the dotlock program, resulting in bugs like #278332
	sed -i -e 's/@DOTLOCK_GROUP@//' \
		Makefile.in || die "sed failed"
}

src_configure() {
	local myconf=(
		# signing and encryption
		# clumpsy blocks for transition period of USE-flag renames
		$(use crypt         && use_enable crypt pgp)
		$(use pgp_classic   && use_enable pgp_classic pgp)
		$(use !crypt && use !pgp_classic && echo "--disable-pgp")

		$(use smime         && use_enable smime)
		$(use smime_classic && use_enable smime_classic smime)
		$(use !smime && use !smime_classic && echo "--disable-smime")

		$(use gpg           && use_enable gpg gpgme)
		$(use gpgme         && use_enable gpgme)
		$(use !gpg && use !gpgme && echo "--disable-gpgme")

		# features
		$(use_enable debug)
		$(use_enable doc)
		$(use_enable nls)
		$(use_enable notmuch)

		# protocols
		$(use_enable imap)
		$(use_enable pop)
		$(use_enable nntp)
		$(use_enable smtp)

		$(use  ssl && use  gnutls && echo --with-gnutls    --without-ssl)
		$(use  ssl && use !gnutls && echo --without-gnutls --with-ssl   )
		$(use !ssl &&                echo --without-gnutls --without-ssl)

		$(use_with sasl)
		$(use_with idn)
		$(use_with kerberos gss)
		"$(use slang && echo --with-slang="${EPREFIX}"/usr || echo a=b)"
		"$(use_with !slang curses "${EPREFIX}"/usr)"

		"--enable-compressed"
		"--enable-external-dotlock"
		"--enable-nfs-fix"
		"--enable-sidebar"
		"--sysconfdir=${EPREFIX}/etc/${PN}"
		"--with-docdir=${EPREFIX}/usr/share/doc/${PN}-${PVR}"
		"--with-regex"
		"--with-exec-shell=${EPREFIX}/bin/sh"
	)

	if [[ ${CHOST} == *-solaris2.* && ${CHOST#*-solaris2.} -le 10 ]] ; then
		# arrows in index view do not show when using wchar_t
		# or misalign due to wrong computations
		myconf+=( "--without-wc-funcs" )
	fi

	# REQUIRED_USE should have selected only one of these
	local hcaches=(
		"berkdb:bdb"
		"gdbm"
		"lmdb"
		"qdbm"
		"tokyocabinet"
	)
	local ucache hcache lcache
	for hcache in "${hcaches[@]}" ; do
		if use ${hcache%%:*} ; then
			ucache=${hcache}
			break
		fi
	done
	if [[ -n ${ucache} ]] ; then
		myconf+=( "--enable-hcache" )
	else
		myconf+=( "--disable-hcache" )
	fi
	for hcache in "${hcaches[@]}" ; do
		[[ ${hcache} == ${ucache} ]] \
			&& myconf+=( "--with-${hcache#*:}" ) \
			|| myconf+=( "--without-${hcache#*:}" )
	done

	if use mbox; then
		myconf+=( "--with-mailpath=${EPREFIX}/var/spool/mail" )
	else
		myconf+=( "--with-homespool=Maildir" )
	fi

	econf "${myconf[@]}" || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	if use mbox; then
		insinto /etc/mutt
		newins "${FILESDIR}"/Muttrc.mbox Muttrc
	else
		insinto /etc/mutt
		doins "${FILESDIR}"/Muttrc
	fi

	# A newer file is provided by app-misc/mime-types. So we link it.
	rm "${ED}"/etc/${PN}/mime.types
	dosym "${EPREFIX}"/etc/mime.types /etc/${PN}/mime.types

	# A man-page is always handy, so fake one
	if use !doc; then
		emake -C doc DESTDIR="${D}" muttrc.man || die
		# make the fake slightly better, bug #413405
		sed -e 's#@docdir@/manual.txt#http://www.mutt.org/doc/devel/manual.html#' \
			-e 's#in @docdir@,#at http://www.mutt.org/,#' \
			-e "s#@sysconfdir@#${EPREFIX}/etc/${PN}#" \
			-e "s#@bindir@#${EPREFIX}/usr/bin#" \
			doc/mutt.man > mutt.1
		cp doc/muttbug.man flea.1
		cp doc/muttrc.man muttrc.5
		doman mutt.1 flea.1 muttrc.5
	else
		# nuke manpages that should be provided by an MTA, bug #177605
		rm "${ED}"/usr/share/man/man5/{mbox,mmdf}.5 \
			|| ewarn "failed to remove files, please file a bug"
	fi

	if use !prefix ; then
		fowners root:mail /usr/bin/mutt_dotlock
		fperms g+s /usr/bin/mutt_dotlock
	fi

	dodoc BEWARE COPYRIGHT ChangeLog NEWS OPS* PATCHES README* TODO VERSION
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		echo
		elog "If you are new to mutt you may want to take a look at"
		elog "the Gentoo QuickStart Guide to Mutt E-Mail:"
		elog "   https://wiki.gentoo.org/wiki/Mutt"
		echo
	fi
	if use crypt || use gpg || use smime ; then
		ewarn "Please note that the crypto related USE-flags of mutt have changed."
		ewarn "To remove some unclarity, the following USE-flags are renamed:"
		ewarn "(see https://bugs.gentoo.org/637176)"
		ewarn "  crypt -> pgp_classic"
		ewarn "  gpg   -> gpgme"
		ewarn "  smime -> smime_classic"
		ewarn "The old USE flags still work but their use is deprecated and will"
		ewarn "be removed in a future release.  Please update your package.use"
		if use gpg && ( use crypt || use smime ) ; then
			ewarn "  Note that gpgme (old gpg) includes both pgp and smime"
			ewarn "  support.  You can probably remove pgp_classic (old crypt)"
			ewarn "  and smime_classic (old smime) from your USE-flags and"
			ewarn "  only enable gpgme."
		fi
	fi
	if use gpgme ; then
		ewarn "Note: in order for Mutt to actually use the gpgme backend"
		ewarn "      you MUST include 'set crypt_use_gpgme=yes' in .muttrc"
		ewarn "      https://dev.mutt.org/doc/manual.html#crypt-use-gpgme"
	fi
}
