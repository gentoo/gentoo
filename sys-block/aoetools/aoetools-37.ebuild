# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="tools for ATA over Ethernet (AoE) network storage protocol"
HOMEPAGE="https://github.com/OpenAoE/aoetools"
SRC_URI="https://github.com/OpenAoE/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~riscv ~sparc x86"

PATCHES=( "${FILESDIR}"/${PN}-32-build.patch )

src_configure() {
	tc-export CC
}
