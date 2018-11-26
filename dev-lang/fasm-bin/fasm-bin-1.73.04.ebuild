# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Flat Assembler for the x86 architecture processors"
HOMEPAGE="https://flatassembler.net/"
KEYWORDS="~amd64"
LICENSE="BSD-2"
SLOT="0"
SRC_URI="https://flatassembler.net/fasm-${PV}.tgz -> ${P}.tgz"
FASM_PN="${PN/-bin}"
S="${WORKDIR}/${FASM_PN}"

src_install()
{
	newbin fasm.x64 fasm
}
