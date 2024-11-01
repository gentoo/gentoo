# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs prefix

DESCRIPTION="Mail delivery agent/filter"
HOMEPAGE="https://www.procmail.org/"
SRC_URI="https://github.com/BuGlessRB/procmail/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="mbox selinux"

DEPEND="
	acct-group/mail
	virtual/mta
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-procmail )
"

src_prepare() {
	# disable flock, using both fcntl and flock style locking
	# doesn't work with NFS with 2.6.17+ kernels, bug #156493

	sed -e "s|/\*#define NO_flock_LOCK|#define NO_flock_LOCK|" \
		-i config.h || die "sed failed"

	eapply "${FILESDIR}/${P}-modern-c.patch"

	if ! use mbox ; then
		echo "# Use maildir-style mailbox in user's home directory" > "${S}"/procmailrc || die
		echo 'DEFAULT=$HOME/.maildir/' >> "${S}"/procmailrc || die
		cd "${S}" || die
		eapply "${FILESDIR}/${P}-maildir.patch"
	else
		echo '# Use mbox-style mailbox in /var/spool/mail' > "${S}"/procmailrc || die
		echo 'DEFAULT=${EPREFIX}/var/spool/mail/$LOGNAME' >> "${S}"/procmailrc || die
	fi

	# Do not use lazy bindings on lockfile and procmail
	if [[ ${CHOST} != *-darwin* ]]; then
		eapply "${FILESDIR}/${P}-lazy-bindings.patch"
	fi

	# Prefixify config.h
	eapply "${FILESDIR}/${P}-gentoo-prefix.patch"
	eprefixify config.h Makefile src/autoconf src/recommend.c

	default
}

src_compile() {
	# bug #875251, bug #896052
	append-flags -std=gnu89
	# bug #859517
	filter-lto

	# -finline-functions (implied by -O3) leaves strstr() in an infinite loop.
	# To work around this, we append -fno-inline-functions to CFLAGS
	# Since GCC 4.7 we also need -fno-ipa-cp-clone (bug #466552)
	# If it's clang, ignore -fno-ipa-cp-clone, as clang doesn't support this
	append-flags -fno-inline-functions
	tc-is-clang || append-flags -fno-ipa-cp-clone

	sed -e "s|CFLAGS0 = -O|CFLAGS0 = ${CFLAGS}|" \
		-e "s|LDFLAGS0= -s|LDFLAGS0 = ${LDFLAGS}|" \
		-e "s|LOCKINGTEST=__defaults__|#LOCKINGTEST=__defaults__|" \
		-e "s|#LOCKINGTEST=/tmp|LOCKINGTEST=/tmp|" \
		-i Makefile || die "sed failed"

	emake CC="$(tc-getCC)"
}

src_install() {
	cd "${S}"/new || die
	insinto /usr/bin
	insopts -m 6755
	doins procmail

	doins lockfile
	fowners root:mail /usr/bin/lockfile
	fperms 2755 /usr/bin/lockfile

	dobin formail mailstat
	insopts -m 0644

	doman *.1 *.5

	cd "${S}" || die
	dodoc FAQ FEATURES HISTORY INSTALL KNOWN_BUGS README

	insinto /etc
	doins procmailrc

	docinto examples
	dodoc examples/*
}

pkg_postinst() {
	if ! use mbox ; then
		elog "Starting with mail-filter/procmail-3.22-r9 you'll need to ensure"
		elog "that you configure a mail storage location using DEFAULT in"
		elog "/etc/procmailrc, for example:"
		elog "\tDEFAULT=\$HOME/.maildir/"
	fi
	if has sfperms ${FEATURES}; then
		ewarn "FEATURES=sfperms removes the read-bit for others from"
		ewarn "  /usr/bin/procmail"
		ewarn "  /usr/bin/lockfile"
		ewarn "If you use procmail from an MTA like Exim, you need to"
		ewarn "re-add the read-bit or avoid the MTA checking the binary"
		ewarn "exists."
	fi
}
