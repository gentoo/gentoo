# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Early unlocking of encrypted systems via ssh for dracut"
HOMEPAGE="https://github.com/dracut-crypt-ssh/dracut-crypt-ssh"
SRC_URI="https://github.com/dracut-crypt-ssh/dracut-crypt-ssh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-kernel/dracut"
RDEPEND="${DEPEND}
	net-misc/dhcp
	net-misc/dropbear"

DOCS=("README.md")
