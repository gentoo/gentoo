# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools ltprune

PACKAGEID=36934 # inriaforge hardcoded ID

DESCRIPTION="C/C++ routines for fast arithmetic in GF(2)[x]"
HOMEPAGE="http://gf2x.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/${PACKAGEID}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="fft static-libs custom-tune"
IUSE_CPU_FLAGS=" pclmul sse2 sse3 sse4_1 ssse3"
IUSE+=" ${IUSE_CPU_FLAGS// / cpu_flags_x86_}"

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
	use static-libs || prune_libtool_files --all
}
