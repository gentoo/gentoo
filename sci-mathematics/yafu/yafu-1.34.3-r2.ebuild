# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic edos2unix toolchain-funcs

MY_PV="$(ver_cut 1-2)"
DESCRIPTION="Yet another factoring utility"
HOMEPAGE="https://sourceforge.net/projects/yafu/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_PV}/${PN}-${MY_PV}-src.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	|| (
		>=sys-devel/gcc-4.2:*[openmp]
		llvm-runtimes/clang-runtime:*[openmp]
	)
	dev-libs/gmp:0=
	sci-mathematics/gmp-ecm"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-fix-makefiles.patch
	"${FILESDIR}"/${P}-mpz_set.patch
)

src_prepare() {
	edos2unix top/eratosthenes/soe_util.c factor/factor_common.c
	default
}

src_compile() {
	tc-export CC
	append-cflags -fcommon
	use amd64 && emake x86_64
	use x86 && emake x86
}

src_test() {
	"${S}"/yafu "factor(121)" || die
}

src_install() {
	dobin "${S}"/yafu
	dodoc docfile.txt README yafu.ini
}
