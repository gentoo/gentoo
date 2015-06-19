# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ftpbase/ftpbase-0.01-r2.ebuild,v 1.9 2013/11/30 13:35:59 naota Exp $

inherit eutils pam user

DESCRIPTION="FTP layout package"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="pam"

DEPEND="pam? ( virtual/pam )
	!<net-ftp/proftpd-1.2.10-r6
	!<net-ftp/pure-ftpd-1.0.20-r2
	!<net-ftp/vsftpd-2.0.3-r1"

S=${WORKDIR}

pkg_setup() {
	# Check if home exists
	local exists=false
	[[ -d "${ROOT}home/ftp" ]] && exists=true

	# Add our default ftp user
	enewgroup ftp 21
	enewuser ftp 21 -1 /home/ftp ftp

	# If home did not exist and does now then we created it in the enewuser
	# command. Now we have to change it's permissions to something sane.
	if [[ ${exists} == "false" && -d "${ROOT}home/ftp" ]] ; then
		chown root:ftp "${ROOT}"home/ftp
	fi
}

src_install() {
	# The ftpusers file is a list of people who are NOT allowed
	# to use the ftp service.
	insinto /etc
	doins "${FILESDIR}/ftpusers" || die

	# Ideally we would create the home directory here with a dodir.
	# But we cannot until bug #9849 is solved - so we kludge in pkg_postinst()

	cp "${FILESDIR}/ftp-pamd-include" "${T}" || die
	if use elibc_FreeBSD; then
		sed -i -e "/pam_listfile.so/s/^.*$/account  required  pam_ftpusers.so no_warn disallow/" \
			"${T}"/ftp-pamd-include || die
	fi
	newpamd "${T}"/ftp-pamd-include ftp
}
