# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

PATCHREV="r0"
PATCHSET="gentoo-${PVR}/${PATCHREV}"

DESCRIPTION="A small but very powerful text-based mail client"
HOMEPAGE="http://www.mutt.org/"
MUTT_G_PATCHES="mutt-gentoo-${PV}-patches-${PATCHREV}.tar.xz"
SRC_URI="ftp://ftp.mutt.org/pub/mutt/${P}.tar.gz
	https://bitbucket.org/${PN}/${PN}/downloads/${P}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/${MUTT_G_PATCHES}"
IUSE="autocrypt berkdb debug doc gdbm gnutls gpgme gsasl +hcache idn +imap kerberos +lmdb mbox nls pgp-classic pop qdbm +sasl selinux slang smime-classic +smtp +ssl tokyocabinet vanilla prefix"
# hcache: allow multiple, bug #607360
REQUIRED_USE="
	gsasl?            ( sasl )
	hcache?           ( || ( berkdb gdbm lmdb qdbm tokyocabinet ) )
	imap?             ( ssl )
	pop?              ( ssl )
	smime-classic?    ( ssl !gnutls )
	smtp?             ( ssl sasl )
	sasl?             ( || ( imap pop smtp ) )
	kerberos?         ( || ( imap pop smtp ) )
	autocrypt?        ( gpgme )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
# yes, we overdepend on the backend impls here, hopefully one day we can
# have REQUIRED_USE do what it is made for again. bug #607360
CDEPEND="
	app-misc/mime-types
	virtual/libiconv

	berkdb?        ( >=sys-libs/db-4:= )
	gdbm?          ( sys-libs/gdbm )
	lmdb?          ( dev-db/lmdb:= )
	qdbm?          ( dev-db/qdbm )
	tokyocabinet?  ( dev-db/tokyocabinet )

	ssl? (
		gnutls?    ( >=net-libs/gnutls-1.0.17:= )
		!gnutls?   ( >=dev-libs/openssl-0.9.6:0= )
	)

	nls?           ( virtual/libintl )
	sasl? (
		gsasl?     ( virtual/gsasl )
		!gsasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	kerberos?      ( virtual/krb5 )
	idn?           ( net-dns/libidn2 )
	gpgme?         ( >=app-crypt/gpgme-0.9.0:= )
	autocrypt?     ( >=dev-db/sqlite-3 )
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
	smime-classic? ( >=dev-libs/openssl-0.9.6:0 )
	pgp-classic? ( app-crypt/gnupg )
"

src_prepare() {
	local PATCHDIR="${WORKDIR}"/mutt-gentoo-${PV}-patches-${PATCHREV}

	if use !vanilla ; then
		# apply patches
		# http://hg.code.sf.net/p/gentoomuttpatches/code/file/mutt-1.10
		local patches=(
			patches-mutt
			bugs-gentoo
			features-common
			features-extra
			gentoo
		)
		local patchset p
		for patchset in "${patches[@]}" ; do
			[[ -d "${PATCHDIR}/${patchset}" ]] || continue
			einfo "Patches for ${PATCHSET} patchset ${patchset}"
			for p in "${PATCHDIR}/${patchset}"/*.patch ; do
				eapply "${p}" || die
			done
		done
		# add some explanation as to why not to go upstream
		sed -i \
			-e '/ReachingUs = N_(/aThis release of Mutt is heavily enriched with patches.\\nFor this reason, any bugs are better reported at https://bugs.gentoo.org/\\nor re-emerge with USE=vanilla and try to reproduce your problem.\\n\\' \
			main.c || die "Failed to add bug instructions"
	fi

	# allow user patches
	eapply_user

	# patch version string for bug reports
	local patchset=
	use vanilla || patchset=", ${PATCHSET}"
	sed -i -e 's|"Mutt %s (%s)"|"Mutt %s (%s'"${patchset}"')"|' \
		muttlib.c || die "failed patching in Gentoo version"

	# bug 864753: avoid warning about missing tools, currently the order
	# is lynx, w3m, elinks, so remove lynx or w3m when not installed,
	# elinks should be there via dep.
	if use doc ; then
		if ! has_version www-client/lynx ; then
			sed -i -e '/lynx/d' doc/Makefile.am || die
		fi
		if ! has_version www-client/w3m ; then
			sed -i -e '/w3m/d' doc/Makefile.am || die
		fi
	fi

	# many patches touch the buildsystem, we always need this
	AT_M4DIR="m4" eautoreconf

	# the configure script contains some "cleverness" whether or not to setgid
	# the dotlock program, resulting in bugs like #278332
	sed -i -e 's/@DOTLOCK_GROUP@//' Makefile.in || die "sed failed"
}

src_configure() {
	local myconf=(
		# signing and encryption
		$(use_enable autocrypt) $(use_with autocrypt sqlite3)
		$(use_enable pgp-classic pgp)
		$(use_enable smime-classic smime)
		$(use_enable gpgme)

		# features
		$(use_enable debug)
		$(use_enable doc)
		$(use_enable nls)

		# protocols
		$(use_enable imap)
		$(use_enable pop)
		$(use_enable smtp)

		$(use  ssl && use  gnutls && echo --with-gnutls    --without-ssl)
		$(use  ssl && use !gnutls && echo --without-gnutls --with-ssl   )
		$(use !ssl &&                echo --without-gnutls --without-ssl)

		$(use  sasl && use  gsasl && echo --with-gsasl    --without-sasl)
		$(use  sasl && use !gsasl && echo --without-gsasl --with-sasl   )
		$(use !sasl &&               echo --without-gsasl --without-sasl)

		$(use_with idn idn2) --without-idn  # avoid automagic libidn dep
		$(use_with kerberos gss)
		"$(use slang && echo --with-slang="${EPREFIX}"/usr || echo a=b)"
		"$(use_with !slang curses "${EPREFIX}"/usr)"

		"--enable-compressed"
		"--enable-external-dotlock"
		"--enable-iconv"
		"--enable-nfs-fix"
		"--enable-sidebar"
		"--sysconfdir=${EPREFIX}/etc/${PN}"
		"--with-docdir=${EPREFIX}/usr/share/doc/${PN}-${PVR}"
		"--without-bundled-regex"     # use the implementation from libc
		"--with-exec-shell=${EPREFIX}/bin/sh"
	)

	if [[ ${CHOST} == *-solaris2.* && ${CHOST#*-solaris2.} -le 10 ]] ; then
		# arrows in index view do not show when using wchar_t
		# or misalign due to wrong computations
		myconf+=( "--without-wc-funcs" )
	fi

	# note: REQUIRED_USE should have selected only one of these, but for
	# bug #607360 we're forced to allow multiple.  For that reason, this
	# list is ordered to preference, and only the first is taken.
	local hcaches=(
		"lmdb"
		"qdbm"
		"tokyocabinet"
		"gdbm"
		"berkdb:bdb"
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

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	insinto /etc/${PN}
	if use mbox; then
		newins "${FILESDIR}"/Muttrc.mbox Muttrc
	else
		doins "${FILESDIR}"/Muttrc
	fi

	# include attachment settings, it's mandatory and shouldn't harm
	# when not being referenced (index_format using %X)
	{
		echo
		echo "# mandatory attachments settings, not setting these is a BUG!"
		echo "# see https://marc.info/?l=mutt-dev&m=158347284923517&w=2"
		grep '^attachments' "${ED}"/etc/${PN}/Muttrc.dist
	} >> "${ED}"/etc/${PN}/Muttrc

	# add setting to actually enable gpgme usage
	if use gpgme || use autocrypt ; then
		{
		echo
		echo "# this setting enables the gpgme backend (via USE=gpgme)"
		# https is broken due to a certificate mismatch :(
		echo "# see http://www.mutt.org/doc/manual/#crypt-use-gpgme"
		echo "set crypt_use_gpgme = yes"
		} >> "${ED}"/etc/${PN}/Muttrc
	fi

	# similar for autocrypt
	if use autocrypt ; then
		{
			echo
			echo "# enables autocrypt (via USE=autocrypt)"
			echo "# see http://www.mutt.org/doc/manual/#autocryptdoc"
			echo "set autocrypt = yes"
		} >> "${ED}"/etc/${PN}/Muttrc
	fi

	# A newer file is provided by app-misc/mime-types. So we link it.
	rm "${ED}"/etc/${PN}/mime.types
	dosym ../mime.types /etc/${PN}/mime.types

	# nuke manpages that should be provided by an MTA, bug #177605
	rm "${ED}"/usr/share/man/man5/{mbox,mmdf}.5 \
		|| ewarn "failed to remove files, please file a bug"

	if use !prefix ; then
		fowners root:mail /usr/bin/mutt_dotlock
		fperms g+s /usr/bin/mutt_dotlock
	fi

	dodoc COPYRIGHT ChangeLog NEWS OPS* PATCHES README* TODO VERSION
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		echo
		elog "If you are new to mutt you may want to take a look at"
		elog "the Gentoo QuickStart Guide to Mutt E-Mail:"
		elog "   https://wiki.gentoo.org/wiki/Mutt"
		echo
	fi
}
