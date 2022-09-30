# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="JIT assembler for x86(IA-32)/x64(AMD64, x86-64)"
HOMEPAGE="https://github.com/herumi/xbyak"
SRC_URI="https://github.com/herumi/xbyak/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() { :; }

src_install() {
	emake install PREFIX="${D}/usr"
}
