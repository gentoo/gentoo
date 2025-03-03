# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dkms git-r3

DESCRIPTION="A linux kernel module that enables calls to ACPI"
HOMEPAGE="https://github.com/nix-community/acpi_call"
EGIT_REPO_URI="https://github.com/teleshoes/acpi_call.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="examples"

CONFIG_CHECK="ACPI"

src_compile() {
	local modargs=( KDIR=${KV_OUT_DIR} )
	local modlist=( acpi_call=misc )

	dkms_src_compile
}

src_install() {
	dkms_src_install

	if use examples; then
		insinto /usr/share/acpi_call
		doins examples/*.sh
	fi
}
