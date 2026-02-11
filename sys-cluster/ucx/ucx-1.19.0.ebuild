# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

MY_PV=${PV/_/-}
DESCRIPTION="Unified Communication X"
HOMEPAGE="https://openucx.org"
SRC_URI="https://github.com/openucx/ucx/releases/download/v${PV}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 -riscv ~x86"
IUSE="+openmp"

RDEPEND="
	sys-libs/binutils-libs:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.19.0-clang21-fix.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {

	BASE_CFLAGS="" econf \
		--disable-doxygen-doc \
		--disable-compiler-opt \
		--without-fuse3 \
		--without-go \
		--without-java \
		$(use_enable openmp)
}

src_compile() {
	BASE_CFLAGS="" emake
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
