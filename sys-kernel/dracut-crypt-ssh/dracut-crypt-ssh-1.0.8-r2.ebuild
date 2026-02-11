# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Early unlocking of encrypted systems via ssh for dracut"
HOMEPAGE="https://github.com/dracut-crypt-ssh/dracut-crypt-ssh"
SRC_URI="https://github.com/dracut-crypt-ssh/dracut-crypt-ssh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="sys-kernel/dracut"
RDEPEND="${DEPEND}
	|| (
		net-misc/connman
		net-misc/dhcp[client]
		net-misc/networkmanager
		sys-apps/systemd
	)
	net-misc/dropbear"

src_prepare() {
	default

	# Fix libdir (hard-coded to "lib64")
	sed "s@/lib64/@/$(get_libdir)/@" \
		-i modules/60crypt-ssh/module-setup.sh \
		|| die
}

src_configure() {
	tc-export CC
	default
}
