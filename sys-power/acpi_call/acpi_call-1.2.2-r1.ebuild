# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="A linux kernel module that enables calls to ACPI"
HOMEPAGE="https://github.com/nix-community/acpi_call"
SRC_URI="https://github.com/nix-community/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh@${GH_TS}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
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
