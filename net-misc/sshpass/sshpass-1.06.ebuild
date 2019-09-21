# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool for noninteractively performing password authentication with ssh"
HOMEPAGE="http://sshpass.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~x64-macos"
IUSE=""

RDEPEND="net-misc/openssh"
