# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper

DESCRIPTION="Another ELF packer for the PS2"
HOMEPAGE="https://github.com/ps2dev/ps2-packer"
SRC_URI="mirror://gentoo/${P}-linux.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="strip"

QA_TEXTRELS="
	opt/ps2-packer/n2e-packer.so
	opt/ps2-packer/n2d-packer.so
	opt/ps2-packer/n2b-packer.so"

QA_WX_LOAD="
	opt/ps2-packer/stub/n2e-0088-stub
	opt/ps2-packer/stub/lzo-0088-stub
	opt/ps2-packer/stub/n2e-asm-1d00-stub
	opt/ps2-packer/stub/null-0088-stub
	opt/ps2-packer/stub/n2e-asm-one-1d00-stub
	opt/ps2-packer/stub/n2e-1d00-stub
	opt/ps2-packer/stub/zlib-1d00-stub
	opt/ps2-packer/stub/n2b-0088-stub
	opt/ps2-packer/stub/n2d-1d00-stub
	opt/ps2-packer/stub/null-1d00-stub
	opt/ps2-packer/stub/n2b-1d00-stub
	opt/ps2-packer/stub/zlib-0088-stub
	opt/ps2-packer/stub/lzo-1d00-stub
	opt/ps2-packer/stub/n2d-0088-stub"

RDEPEND="sys-libs/glibc"

src_install() {
	insinto /opt/${PN}
	doins -r README.txt stub

	exeinto /opt/${PN}
	doexe *.so ps2-packer

	make_wrapper ${PN} /opt/${PN}/${PN}
}
