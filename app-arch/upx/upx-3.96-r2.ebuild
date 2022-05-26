# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Ultimate Packer for eXecutables (free version using UCL compression and not NRV)"
HOMEPAGE="https://upx.github.io/"
SRC_URI="https://github.com/upx/upx/releases/download/v${PV}/${P}-src.tar.xz"

LICENSE="GPL-2+ UPX-exception" # Read the exception before applying any patches
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-libs/ucl-1.03
	sys-libs/zlib"
RDEPEND="${RDEPEND}
	!app-arch/upx-bin"
BDEPEND="
	app-arch/xz-utils[extra-filters]
	dev-lang/perl"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}/${P}_CVE-2020-24119.patch"
	"${FILESDIR}/${P}_CVE-2021-20285.patch"
)

src_compile() {
	tc-export CXX
	emake CXXFLAGS_WERROR="" all
}

src_install() {
	newbin src/upx.out upx
	dodoc BUGS NEWS PROJECTS README* THANKS doc/*.txt doc/upx.html
	doman doc/upx.1
}
