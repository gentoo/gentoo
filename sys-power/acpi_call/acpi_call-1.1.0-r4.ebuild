# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils linux-info linux-mod

if [ "${PV}" = "9999" ]; then
	inherit git-2
	EGIT_REPO_URI="https://github.com/mkottman/acpi_call.git"
	KEYWORDS=""
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/mkottman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A kernel module that enables you to call ACPI methods"
HOMEPAGE="https://github.com/mkottman/acpi_call"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

CONFIG_CHECK="ACPI"
MODULE_NAMES="acpi_call(misc:${S})"
BUILD_TARGETS="default"

src_prepare() {
	epatch "${FILESDIR}/${P}-linux-3.17.patch"
}

src_compile() {
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}
