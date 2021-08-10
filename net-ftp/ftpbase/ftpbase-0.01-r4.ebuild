# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam

DESCRIPTION="FTP layout package"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="pam"

DEPEND="pam? ( sys-libs/pam )
	!<net-ftp/proftpd-1.2.10-r6
	!<net-ftp/pure-ftpd-1.0.20-r2
	!<net-ftp/vsftpd-2.0.3-r1"
RDEPEND="
	acct-group/ftp
	acct-user/ftp"

S=${WORKDIR}

src_install() {
	# The ftpusers file is a list of people who are NOT allowed
	# to use the ftp service.
	insinto /etc
	doins "${FILESDIR}/ftpusers"

	if use pam; then
		newpamd "${FILESDIR}"/ftp-pamd-include ftp
	fi
}
