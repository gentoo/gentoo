# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pam

DESCRIPTION="File Transfer Protocol (FTP) base layout"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="pam zeroconf"

DEPEND="
	pam? ( sys-libs/pam )
	zeroconf? ( net-dns/avahi )
"

RDEPEND="
	acct-group/ftp
	acct-user/ftp
"

src_install() {
	# The ftpusers file is a list of people who are NOT allowed
	# to use the ftp service.
	insinto /etc
	doins "${FILESDIR}/ftpusers"

	use pam	&& newpamd "${FILESDIR}"/ftp-pamd-include ftp

	if use zeroconf; then
		insinto /etc/avahi/services
		doins "${FILESDIR}/ftp.service"
	fi
}
