# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit pam

DESCRIPTION="MTA layout package"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="pam"

RDEPEND="
	acct-group/mail
	acct-user/mail
	acct-user/postmaster
	pam? ( sys-libs/pam )
"

src_install() {
	insinto /etc/mail
	doins "${FILESDIR}"/aliases
	insinto /etc
	newins "${FILESDIR}"/mailcap-r3 mailcap
	doman "${FILESDIR}"/mailcap.5

	dosym spool/mail /var/mail

	if use pam ; then
		newpamd "${FILESDIR}"/common-pamd-include pop
		newpamd "${FILESDIR}"/common-pamd-include imap
		local p
		for p in pop3 pop3s pops ; do
			dosym pop /etc/pam.d/${p}
		done
		for p in imap4 imap4s imaps ; do
			dosym imap /etc/pam.d/${p}
		done
	fi
}
