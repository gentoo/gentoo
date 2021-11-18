# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C/C++ routines for fast arithmetic in GF(2)[x]"
HOMEPAGE="https://gitlab.inria.fr/thome/gf2x/ https://gforge.inria.fr/projects/gf2x/"
# The Gitlab release is missing the autotools files.
SRC_URI="https://gforge.inria.fr/frs/download.php/38243/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3" # soname major version, defined in configure.ac
KEYWORDS="amd64 ~arm64 ppc ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="fft static-libs custom-tune"
IUSE_CPU_FLAGS=" pclmul sse2 sse3 sse4_1 ssse3"
IUSE+=" ${IUSE_CPU_FLAGS// / cpu_flags_x86_}"

PATCHES=(
	"${FILESDIR}/fno-common.patch"
	"${FILESDIR}/${P}-0001-src-tunefft.c-add-include-statement-for-MIN-and-MAX.patch"
)

src_prepare() {
	default
	# fix for cross-compiling, avoid ABI detection
	sed -e 's/VERIFY_WORDSIZE(\[$ABI\].*/echo "skipping ABI check"/' \
		-e 's/AC_MSG_ERROR(\[already_t.*/echo "skipping ABI check"/' \
		-i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse41) \
		$(use_enable cpu_flags_x86_pclmul pclmul) \
		$(use_enable fft fft-interface) \
		$(use_enable static-libs static)
}

src_compile() {
	emake
	if use custom-tune; then
		einfo "Starting tuning"
		emake tune-lowlevel
		emake tune-toom
		use fft && emake tune-fft
	fi
}

src_install() {
	default
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
