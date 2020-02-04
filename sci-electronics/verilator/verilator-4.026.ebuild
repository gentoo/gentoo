# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The fast free Verilog/SystemVerilog simulator"
HOMEPAGE="https://www.veripool.org/wiki/verilator"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.veripool.org/git/${PN}"
else
	SRC_URI="http://www.veripool.org/ftp/${P}.tgz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
fi

LICENSE="|| ( Artistic-2 LGPL-3 )"
SLOT="0"

DEPEND="
	dev-lang/perl
	sys-libs/zlib
"

RDEPEND="
	${DEPEND}
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

src_prepare() {
	default
	eautoconf --force
}
