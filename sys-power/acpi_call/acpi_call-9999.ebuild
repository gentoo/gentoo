# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 linux-info linux-mod

DESCRIPTION="A linux kernel module that enables calls to ACPI"
HOMEPAGE="https://github.com/nix-community/acpi_call"
EGIT_REPO_URI="https://github.com/teleshoes/acpi_call.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="examples"

BUILD_TARGETS="default"
CONFIG_CHECK="ACPI"
MODULE_NAMES="acpi_call(misc:${S})"

src_compile() {
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"

	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	if use examples; then
		insinto /usr/share/acpi_call
		doins examples/*.sh
	fi
}
