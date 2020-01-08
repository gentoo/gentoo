# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit pam

DESCRIPTION="MTA layout package"
SRC_URI=""
HOMEPAGE="https://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="pam"

RDEPEND="
	acct-group/mail
	acct-user/mail
	acct-user/postmaster
	pam? ( sys-libs/pam )"

S=${WORKDIR}

src_install() {
	dodir /etc/mail
	insinto /etc/mail
	doins "${FILESDIR}"/aliases
	insinto /etc
	doins "${FILESDIR}"/mailcap
	doman "${FILESDIR}"/mailcap.5

	dosym spool/mail /var/mail

	newpamd "${FILESDIR}"/common-pamd-include pop
	newpamd "${FILESDIR}"/common-pamd-include imap
	if use pam ; then
		local p
		for p in pop3 pop3s pops ; do
			dosym pop /etc/pam.d/${p}
		done
		for p in imap4 imap4s imaps ; do
			dosym imap /etc/pam.d/${p}
		done
	fi
}
