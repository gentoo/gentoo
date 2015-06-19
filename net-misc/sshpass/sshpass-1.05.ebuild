# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sshpass/sshpass-1.05.ebuild,v 1.6 2015/01/31 16:54:19 darkside Exp $

EAPI="4"

DESCRIPTION="Tool for noninteractively performing password authentication with ssh"
HOMEPAGE="http://sshpass.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~arm x86 ~x64-macos"
IUSE=""

RDEPEND="net-misc/openssh"
DEPEND=""
