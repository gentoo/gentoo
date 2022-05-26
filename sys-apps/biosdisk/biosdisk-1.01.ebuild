# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FreeDOS based BIOS updating utility for Dell machines"
HOMEPAGE="https://github.com/dell/biosdisk"
SRC_URI="https://github.com/dell/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-cdr/cdrtools
	sys-boot/grub
	sys-boot/syslinux
"

src_prepare() {
	default

	sed -e 's/biosdisk.8.gz/biosdisk.8/g' -e '/gzip/d' -i Makefile || die
}

src_install() {
	default

	keepdir /var/lib/biosdisk
}
