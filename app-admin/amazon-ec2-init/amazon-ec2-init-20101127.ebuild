# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="Init script to setup Amazon EC2 instance parameters"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

# Amazon only provides x86 and amd64 Linux Xen guests, possibly FreeBSD,
# so just don't go adding further keywords.
KEYWORDS="-* ~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="net-misc/wget"
DEPEND=""

src_install() {
	newinitd "${FILESDIR}/amazon-ec2.init" amazon-ec2 || die
}

pkg_postinst() {
	elog "Remember to add amazon-ec2 init script to your boot runlevel"
	elog "otherwise it won't bring up the correct interfaces and won't."
	elog "start before the hostname has been set."
}
