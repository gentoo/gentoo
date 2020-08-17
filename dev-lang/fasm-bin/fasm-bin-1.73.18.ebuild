# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Flat Assembler for the x86 architecture processors"
HOMEPAGE="https://flatassembler.net/"
SRC_URI="https://flatassembler.net/fasm-${PV}.tgz -> ${P}.tgz"

LICENSE="FASM"
SLOT="0"
KEYWORDS="~amd64"

FASM_PN="${PN/-bin}"
S="${WORKDIR}/${FASM_PN}"
QA_PREBUILT="/usr/bin/fasm"

src_install() {
	newbin fasm.x64 fasm
}
