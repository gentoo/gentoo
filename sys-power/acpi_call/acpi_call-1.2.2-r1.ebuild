# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="A linux kernel module that enables calls to ACPI"
HOMEPAGE="https://github.com/nix-community/acpi_call"
SRC_URI="https://github.com/nix-community/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples"

CONFIG_CHECK="ACPI"

src_compile() {
	local modargs=( KDIR=${KV_OUT_DIR} )
	local modlist=( acpi_call=misc )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	if use examples; then
		insinto /usr/share/acpi_call
		doins examples/*.sh
	fi
}
