# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Ultimate Packer for eXecutables (free version using UCL compression and not NRV)"
HOMEPAGE="http://upx.github.io/"
SRC_URI="https://github.com/upx/upx/releases/download/v${PV}/${P}-src.tar.xz"

LICENSE="GPL-2+ UPX-exception" # Read the exception before applying any patches
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/ucl-1.03
	sys-libs/zlib
	!app-arch/upx-bin"
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}-src"

src_compile() {
	tc-export CXX
	emake CXXFLAGS_WERROR="" all
}

src_install() {
	newbin src/upx.out upx
	dodoc BUGS NEWS PROJECTS README* THANKS doc/*.txt doc/upx.html
	doman doc/upx.1
}
