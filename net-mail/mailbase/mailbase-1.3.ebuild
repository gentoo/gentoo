# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit pam eutils user

DESCRIPTION="MTA layout package"
SRC_URI=""
HOMEPAGE="https://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="pam"

RDEPEND="pam? ( virtual/pam )"

S=${WORKDIR}

pkg_setup() {
	enewgroup mail 12
	enewuser mail 8 -1 /var/spool/mail mail
	enewuser postmaster 14 -1 /var/spool/mail
}

src_install() {
	dodir /etc/mail
	insinto /etc/mail
	doins "${FILESDIR}"/aliases
	insinto /etc
	doins "${FILESDIR}"/mailcap

	keepdir /var/spool/mail
	fowners root:mail /var/spool/mail
	fperms 03775 /var/spool/mail
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

get_permissions_oct() {
	if [[ ${USERLAND} = GNU ]] ; then
		stat -c%a "${ROOT}$1"
	elif [[ ${USERLAND} = BSD ]] ; then
		stat -f%p "${ROOT}$1" | cut -c 3-
	fi
}

pkg_postinst() {
	# bug 614396
	if [[ "$(get_permissions_oct /var/spool/mail)" != "3775" ]] ; then
		einfo  "Fixing ${ROOT}var/spool/mail/ permissions"
		chown root:mail "${ROOT}var/spool/mail/"
		chmod 03775 "${ROOT}var/spool/mail/"
	fi
}
