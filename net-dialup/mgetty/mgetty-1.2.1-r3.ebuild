# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="A programm for sending and receiving fax and voice"
HOMEPAGE="http://mgetty.greenie.net/"
SRC_URI="ftp://mgetty.greenie.net/pub/mgetty/source/$(ver_cut 1-2)/${P}.tar.gz"

DEPEND="
	dev-lang/perl
	sys-apps/groff
	sys-apps/texinfo
	virtual/awk
	fax? ( !net-misc/efax )
"

RDEPEND="
	${DEPEND}
	acct-group/fax
	acct-user/fax
	fax? (
		app-text/ghostscript-gpl
		media-libs/netpbm
	)
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="+fax fidonet split-usr"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.36-callback.patch
	"${FILESDIR}"/${PN}-1.1.36-tmpfile.patch
	"${FILESDIR}"/${PN}-1.1.37-qa-fixes.patch
	"${FILESDIR}"/${PN}-1.2.1-Lucent.c.patch
	"${FILESDIR}"/${PN}-1.2.1-gentoo.patch
	"${FILESDIR}"/${PN}-1.2.1-aarch64.patch
)

src_prepare() {
	default

	chmod +x mkidirs || die

	# don't install fax related files - bug #195467
	use fax || eapply "${FILESDIR}/${PN}-1.1.37-nofax.patch"

	sed -i -e 's:/usr/local/lib/mgetty+sendfax:/etc/mgetty+sendfax:' faxrunq.config || die 'changing mgetty config dir failed'
	sed -i -e 's:/usr/local/bin/g3cat:/usr/bin/g3cat:' faxrunq.config fax/faxspool.rules || die 'changing g3cat path failed'

	sed -e "/^doc-all:/s/mgetty.asc mgetty.info mgetty.dvi mgetty.ps/mgetty.info/" \
		-i doc/Makefile || die 'first sed on doc/Makefile failed'

	sed -i \
		-e 's:^CC=:CC?=:g' \
		-e 's:^CFLAGS=:CFLAGS?=:g' \
		{,*/}Makefile || die
	sed -i \
		-e 's:^AR=:AR?=:g' \
		-e 's:^CFLAGS=:CFLAGS+= -I..:g' \
		-e 's:^RANLIB=:RANLIB?=:g' \
		*/Makefile || die
}

src_configure() {
	tc-export AR CC RANLIB
	use fidonet && append-cppflags "-DFIDO"
	append-cppflags "-DAUTO_PPP"

	sed -e 's:var/log/mgetty:var/log/mgetty/mgetty:' \
		-e 's:var/log/sendfax:var/log/mgetty/sendfax:' \
		-e 's:\/\* \(\#define CNDFILE "dialin.config"\) \*\/:\1:' \
		-e 's:\(\#define FAX_NOTIFY_PROGRAM\).*:\1 "/etc/mgetty+sendfax/new_fax":' \
		policy.h-dist > policy.h || die 'creating policy.h failed'

	sed -i \
		-e "s/\$(CFLAGS) -o newslock/${CFLAGS} ${LDFLAGS} -Wall -o newslock/" \
		-e "s/\$(LDLAGS)/${LDFLAGS}/" \
		{,fax/}Makefile || die
}

src_compile() {
	local target
	for target in mgetty sedscript all vgetty;do
		VARTEXFONTS="${T}"/fonts emake prefix=/usr \
			CONFDIR=/etc/mgetty+sendfax \
			CFLAGS="${CFLAGS} ${CPPFLAGS}" \
			LDFLAGS="${LDFLAGS}" \
			${target}
	done
}

src_install() {
	# parallelization issue: vgetty-install target fails if install target
	#                        isn't finished
	local target
	for target in install "vgetty-install install-callback"; do
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
			${target}
	done

	keepdir /var/log/mgetty

	# Install mgetty into /sbin (#119078)
	if use split-usr; then
		dodir /sbin
		mv "${D}"/usr/sbin/mgetty "${D}"/sbin || die
		dosym ../../sbin/mgetty /usr/sbin/mgetty
	fi

	# Don't install ct (#106337)
	rm "${D}"/usr/bin/ct || die "failed to remove useless ct program"

	dodoc BUGS ChangeLog README.1st Recommend THANKS TODO \
		doc/*.txt doc/modems.db
	doinfo doc/mgetty.info

	docinto vgetty
	dodoc voice/{Readme,Announce,ChangeLog,Credits}

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

	systemd_newunit "${FILESDIR}"/mgetty.service mgetty@.service
}

pkg_postinst() {
	elog "Users who wish to use the fax or voicemail capabilities must be members"
	elog "of the group fax in order to access files"
	elog
	elog "If you want to grab voice messages from a remote location, you must save"
	elog "the password in /var/spool/voice/.code file"
}
