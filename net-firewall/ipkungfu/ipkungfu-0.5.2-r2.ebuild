# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A nice iptables firewall script"
HOMEPAGE="http://www.linuxkungfu.org/"
SRC_URI="http://www.linuxkungfu.org/ipkungfu/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="net-firewall/iptables"
RDEPEND="${DEPEND}
	virtual/logger"

src_unpack() {
	unpack ${A}

	# Patch ipkungfu to load the right module for ip_nat_ftp
	# Fixes bug #42443.  Thanks to George L. Emigh <george@georgelemigh.com>
	cd "${WORKDIR}"/${P} && epatch "${FILESDIR}"/nat_ftp.patch

	# man page comes bzip2'd, so bunzip2 it.
	cd "${WORKDIR}"/${P}/files
	bunzip2 ipkungfu.8.bz2
}

src_install() {

	# Package comes with a hard coded shell script, so here we
	# replicate what they did, but so it's compatible with portage.

	# Install shell script executable
	dosbin ipkungfu

	# Install Gentoo init script
	newinitd "${FILESDIR}"/ipkungfu.init ipkungfu

	# Install config files into /etc
	dodir /etc/ipkungfu
	insinto /etc/ipkungfu
	doins files/*.conf

	# Install man page
	doman files/ipkungfu.8

	# Install documentation
	dodoc COPYRIGHT Changelog FAQ INSTALL README gpl.txt
}

pkg_postinst() {
	einfo "Be sure to edit the config files"
	einfo "in /etc/ipkungfu before running"
}
