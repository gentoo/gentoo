# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils flag-o-matic autotools

NEOMUTT="neomutt-20160710"

DESCRIPTION="A small but very powerful text-based mail client"
HOMEPAGE="http://www.mutt.org/"
SRC_URI="ftp://ftp.mutt.org/pub/mutt/${P}.tar.gz
	https://bitbucket.org/${PN}/${PN}/downloads/${P}.tar.gz
	https://github.com/neomutt/integration/archive/${NEOMUTT}.tar.gz -> ${P}-patches-${NEOMUTT}.tar.gz"
IUSE="berkdb crypt debug doc gdbm gnutls gpg idn imap kerberos libressl mbox nls nntp notmuch pop qdbm sasl selinux sidebar slang smime smtp ssl tokyocabinet"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~x86 ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
CDEPEND="
	app-misc/mime-types
	nls? ( virtual/libintl )
	tokyocabinet?  ( dev-db/tokyocabinet )
	!tokyocabinet? (
		qdbm?  ( dev-db/qdbm )
		!qdbm? (
			gdbm?  ( sys-libs/gdbm )
			!gdbm? ( berkdb? ( >=sys-libs/db-4 ) )
		)
	)
	imap?    (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? (
			ssl? (
				!libressl? ( >=dev-libs/openssl-0.9.6:0 )
				libressl? ( dev-libs/libressl )
			)
		)
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	kerberos? ( virtual/krb5 )
	pop?     (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? (
			ssl? (
				!libressl? ( >=dev-libs/openssl-0.9.6:0 )
				libressl? ( dev-libs/libressl )
			)
		)
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	smtp?     (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? (
			ssl? (
				!libressl? ( >=dev-libs/openssl-0.9.6:0 )
				libressl? ( dev-libs/libressl )
			)
		)
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	idn?     ( net-dns/libidn )
	gpg?     ( >=app-crypt/gpgme-0.9.0 )
	smime?   (
		!libressl? ( >=dev-libs/openssl-0.9.6:0 )
		libressl? ( dev-libs/libressl )
	)
	notmuch? ( net-mail/notmuch )
	slang? ( sys-libs/slang )
	!slang? ( >=sys-libs/ncurses-5.2:0 )
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

src_prepare() {
	local PATCHDIR="${WORKDIR}"/integration-${NEOMUTT}

	# apply NeoMutt patches
	export EPATCH_FORCE="yes"
	export EPATCH_SUFFIX="patch"
	# order of patches from README.md
	local patches=(
		bugs-common
		features-common
		features-extra
		bugs-neomutt
		gentoo-pre
		gentoo
	)
	local patchset
	for patchset in "${patches[@]}" ; do
		einfo "Applying NeoMutt ${NEOMUTT} patchset ${patchset}"
		EPATCH_SOURCE="${PATCHDIR}"/${patchset} epatch \
			|| die "NeoMutt patchset ${patchset} failed"
	done
	# add some explanation as to why not going to upstream
	sed -i \
		-e '/ReachingUs = N_(/a\"This release of Mutt is heavily enriched by NeoMutt patches.\\nFor this reason, any bugs are better reported at https://bugs.gentoo.org/\\nor directly to the NeoMutt project.\\n\\n"' \
		version.c || die "Failed to add bug instructions"

	local upatches=
	# allow user patches
	eapply_user && upatches=" with user patches"

	# patch version string for bug reports
	rm VERSION.neo || die  # we already flag it appropriate
	sed -i -e 's/"Mutt %s (%s)"/"Mutt %s (%s, Gentoo '"${PVR}${upatches}, NeoMutt ${NEOMUTT})"'"/' \
		muttlib.c || die "failed patching in Gentoo version"

	# many patches touch the buildsystem, we always need this
	AT_M4DIR="m4" eautoreconf

	# the configure script contains some "cleverness" whether or not to setgid
	# the dotlock program, resulting in bugs like #278332
	sed -i -e 's/@DOTLOCK_GROUP@//' \
		Makefile.in || die "sed failed"

	# don't just build documentation (lengthy process, with big dependencies)
	if use !doc ; then
		sed -i -e '/SUBDIRS =/s/doc//' Makefile.in || die
	fi
}

src_configure() {
	local myconf="
		$(use_enable crypt pgp) \
		$(use_enable debug) \
		$(use_enable gpg gpgme) \
		$(use_enable imap) \
		$(use_enable nls) \
		$(use_enable nntp) \
		$(use_enable pop) \
		$(use_enable sidebar) \
		$(use_enable smime) \
		$(use_enable smtp) \
		$(use_enable notmuch) \
		$(use_with idn) \
		$(use_with kerberos gss) \
		$(use slang && echo --with-slang=${EPREFIX}/usr) \
		$(use !slang && echo --with-curses=${EPREFIX}/usr) \
		--enable-compressed \
		--enable-external-dotlock \
		--enable-nfs-fix \
		--sysconfdir=${EPREFIX}/etc/${PN} \
		--with-docdir=${EPREFIX}/usr/share/doc/${PN}-${PVR} \
		--with-regex \
		--with-exec-shell=${EPREFIX}/bin/sh"

	if [[ ${CHOST} == *-solaris* ]] ; then
		# arrows in index view do not show when using wchar_t
		myconf+=" --without-wc-funcs"
	fi

	# mutt prioritizes gdbm over bdb, so we will too.
	# hcache feature requires at least one database is in USE.
	if use tokyocabinet; then
		myconf="${myconf} --enable-hcache \
			--with-tokyocabinet --without-qdbm --without-gdbm --without-bdb"
	elif use qdbm; then
		myconf="${myconf} --enable-hcache \
			--without-tokyocabinet --with-qdbm --without-gdbm --without-bdb"
	elif use gdbm ; then
		myconf="${myconf} --enable-hcache \
			--without-tokyocabinet --without-qdbm --with-gdbm --without-bdb"
	elif use berkdb; then
		myconf="${myconf} --enable-hcache \
			--without-tokyocabinet --without-qdbm --without-gdbm --with-bdb"
	else
		myconf="${myconf} --disable-hcache \
			--without-tokyocabinet --without-qdbm --without-gdbm --without-bdb"
	fi

	# there's no need for gnutls, ssl or sasl without socket support
	if use pop || use imap || use smtp ; then
		if use gnutls; then
			myconf="${myconf} --with-gnutls"
		elif use ssl; then
			myconf="${myconf} --with-ssl"
		fi
		# not sure if this should be mutually exclusive with the other two
		myconf="${myconf} $(use_with sasl)"
	else
		myconf="${myconf} --without-gnutls --without-ssl --without-sasl"
	fi

	if use mbox; then
		myconf="${myconf} --with-mailpath=${EPREFIX}/var/spool/mail"
	else
		myconf="${myconf} --with-homespool=Maildir"
	fi

	econf ${myconf} || die "configure failed"
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
	dosym /etc/mime.types /etc/${PN}/mime.types

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
	else
		echo
		elog "This version of Mutt is entirely based on NeoMutt patches."
		elog "Please visit http://www.neomutt.org/ to learn more about this project."
		elog "As a result, SmartTime functionality has been replaced with"
		elog "CondDate feature.  To mimic SmartTime, use this CondDate formatter:"
		elog "%<[12m?%<[7d?%<[12H?%[%H:%M ]&%[%a-%d]>&%[%d-%b]>&%[%b-%y]>"
		echo
	fi
}
