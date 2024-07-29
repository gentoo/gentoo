# Copyright 1999-2024 Gentoo Authors
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
KEYWORDS="~amd64 -riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="+numa +openmp"

RDEPEND="
	sys-libs/binutils-libs:=
	numa? ( sys-process/numactl )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.13.0-drop-werror.patch
	"${FILESDIR}"/${PN}-1.13.0-fix-bashisms.patch
	"${FILESDIR}"/${PN}-1.13.0-fix-fcntl-include-musl.patch
	"${FILESDIR}"/${PN}-1.13.0-cstdint-include.patch
	"${FILESDIR}"/${PN}-1.13.0-binutils-2.39-ptr-typedef.patch
	"${FILESDIR}"/${PN}-1.13.0-no-rpm-sandbox.patch
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
		$(use_enable numa) \
		$(use_enable openmp)
}

src_compile() {
	BASE_CFLAGS="" emake
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
