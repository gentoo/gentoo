# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="New Flat Assembler engine, successor of the one used by flat assembler 1"
HOMEPAGE="https://flatassembler.net/"
KEYWORDS="~amd64"
LICENSE="BSD-2"
SLOT="0"
SRC_URI="https://flatassembler.net/fasmg.zip -> ${P}.zip"
S="${WORKDIR}"

src_install()
{
	dobin fasmg
}
