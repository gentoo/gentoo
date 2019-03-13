# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="early unlocking of encrypted systems via ssh for dracut"
HOMEPAGE="https://github.com/dracut-crypt-ssh/dracut-crypt-ssh"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-kernel/dracut"
RDEPEND="${DEPEND}
	net-misc/dhcp
	net-misc/dropbear"

DOCS=("README.md")
