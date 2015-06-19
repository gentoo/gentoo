# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/mgetty/mgetty-1.1.37-r1.ebuild,v 1.8 2015/03/24 20:07:03 maekke Exp $

EAPI=5
inherit eutils flag-o-matic toolchain-funcs user

DESCRIPTION="fax and voice modem programs"
SRC_URI="ftp://mgetty.greenie.net/pub/mgetty/source/1.1/${PN}${PV}-Jun05.tar.gz"
HOMEPAGE="http://mgetty.greenie.net/"

DEPEND="doc? ( virtual/latex-base virtual/texi2dvi )
	>=sys-apps/sed-4
	sys-apps/groff
	dev-lang/perl
	sys-apps/texinfo
	virtual/awk
	fax? (
		!net-misc/efax
		!net-misc/hylafax
	)"
RDEPEND="${DEPEND}
	fax? ( media-libs/netpbm app-text/ghostscript-gpl )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ~ppc64 sparc x86"
IUSE="doc +fax fidonet"

pkg_setup() {
	enewgroup fax
	enewuser fax -1 -1 /dev/null fax
}

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-qa-fixes.patch"
	epatch "${FILESDIR}/${PN}-1.1.36-callback.patch" # add callback install to Makefile
	epatch "${FILESDIR}/Lucent.c.patch" # Lucent modem CallerID patch - bug #80366
	use fax || epatch "${FILESDIR}/${P}-nofax.patch" # don't install fax related files - bug #195467
	epatch "${FILESDIR}/${PN}-1.1.36-tmpfile.patch" # fix security bug 235806

	sed -e 's:var/log/mgetty:var/log/mgetty/mgetty:' \
		-e 's:var/log/sendfax:var/log/mgetty/sendfax:' \
		-e 's:\/\* \(\#define CNDFILE "dialin.config"\) \*\/:\1:' \
		-e 's:\(\#define FAX_NOTIFY_PROGRAM\).*:\1 "/etc/mgetty+sendfax/new_fax":' \
		policy.h-dist > policy.h || die 'creating policy.h failed'

	sed -i -e 's:/usr/local/lib/mgetty+sendfax:/etc/mgetty+sendfax:' faxrunq.config || die 'changing mgetty config dir failed'
	sed -i -e 's:/usr/local/bin/g3cat:/usr/bin/g3cat:' faxrunq.config fax/faxspool.rules || die 'changing g3cat path failed'

	sed -e "/^doc-all:/s/mgetty.asc mgetty.info mgetty.dvi mgetty.ps/mgetty.info/" \
		-i doc/Makefile || die 'first sed on doc/Makefile failed'
	if use doc; then
		sed -i \
			-e "s/^doc-all:/doc-all: mgetty.ps/" \
			-e "s/^all:/all: doc-all/" \
			doc/Makefile || die 'second sed on doc/Makefile failed'
	fi

	# Support user's CFLAGS and LDFLAGS.
	sed -e "s/\$(CFLAGS) -o newslock/${CFLAGS} ${LDFLAGS} -Wall -o newslock/" \
		-e "s/\$(LDLAGS)/${LDFLAGS}/" -i {,fax/}Makefile || die
}

src_compile() {
	use fidonet && append-cppflags "-DFIDO"
	append-cppflags "-DAUTO_PPP"
	# bug #299421
	VARTEXFONTS="${T}"/fonts emake -j1 prefix=/usr \
		CC="$(tc-getCC)" \
		CONFDIR=/etc/mgetty+sendfax \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		all vgetty
}

src_install () {
	# parallelization issue: vgetty-install target fails if install target
	#                        isn't finished
	local targets
	for targets in install "vgetty-install install-callback"; do
		emake prefix="${D}/usr" \
			INFODIR="${D}/usr/share/info" \
			CONFDIR="${D}/etc/mgetty+sendfax" \
			MAN1DIR="${D}/usr/share/man/man1" \
			MAN4DIR="${D}/usr/share/man/man4" \
			MAN5DIR="${D}/usr/share/man/man5" \
			MAN8DIR="${D}/usr/share/man/man8" \
			SBINDIR="${D}/usr/sbin" \
			BINDIR="${D}/usr/bin" \
			VOICE_DIR="${D}/var/spool/voice" \
			PHONE_GROUP=fax \
			PHONE_PERMS=755 \
			spool="${D}/var/spool" \
			${targets}
	done

	keepdir /var/log/mgetty

	#Install mgetty into /sbin (#119078)
	dodir /sbin && \
		mv "${D}"/usr/sbin/mgetty "${D}"/sbin && \
		dosym /sbin/mgetty /usr/sbin/mgetty || die "failed to install /sbin/mgetty"
	#Don't install ct (#106337)
	rm "${D}"/usr/bin/ct || die "failed to remove useless ct program"

	dodoc BUGS ChangeLog README.1st Recommend THANKS TODO \
		doc/*.txt doc/modems.db
	doinfo doc/mgetty.info

	docinto vgetty
	dodoc voice/{Readme,Announce,ChangeLog,Credits}

	if use doc; then
		dodoc doc/mgetty.ps
	fi

	docinto vgetty/doc
	dodoc voice/doc/*

	if use fax; then
		mv samples/new_fax.all samples_new_fax.all || die "move failed."
		docinto samples
		dodoc samples/*

		docinto samples/new_fax
		dodoc samples_new_fax.all/*
	fi

	if ! use fax; then
		insinto /usr/share/${PN}/frontends
		doins -r frontends/{voice,network}
	else
		insinto /usr/share/${PN}
		doins -r frontends
	fi
	insinto /usr/share/${PN}
	doins -r patches
	insinto /usr/share/${PN}/voice
	doins -r voice/{contrib,Perl,scripts}

	diropts -m 0750 -o fax -g fax
	dodir /var/spool/voice
	keepdir /var/spool/voice/incoming
	keepdir /var/spool/voice/messages
	if use fax; then
		dodir /var/spool/fax
		dodir /var/spool/fax/outgoing
		keepdir /var/spool/fax/outgoing/locks
		keepdir /var/spool/fax/incoming
	fi
}

pkg_postinst() {
	elog "Users who wish to use the fax or voicemail capabilities must be members"
	elog "of the group fax in order to access files"
	elog
	elog "If you want to grab voice messages from a remote location, you must save"
	elog "the password in /var/spool/voice/.code file"
	echo
	ewarn "/var/spool/voice/.code and /var/spool/voice/messages/Index"
	ewarn "are not longer created by this automatically!"
}
