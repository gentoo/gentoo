# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mount-boot

MY_PN=gentoo-grub-themes

DESCRIPTION="Grub2 Themes for Gentoo"
HOMEPAGE="https://github.com/Telemin/gentoo-grub-themes"
SRC_URI="https://github.com/Telemin/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tgz"
S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="MIT CC-BY-SA-2.5"
SLOT="0"

KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

PDEPEND="sys-boot/grub"

src_install() {
	local d
	for d in /boot /usr/share; do
		insinto "${d}"/grub/themes
		doins -r gentoo_frosted gentoo_glass gentoo_minimalist
	done
}
