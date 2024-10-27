# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Free UCI chess engine, claimed to be the strongest in the world"
HOMEPAGE="https://stockfishchess.org/"

NNUE_FILES="nn-1111cefa1111.nnue nn-37f18f62d772.nnue"

SRC_URI="https://github.com/official-stockfish/Stockfish/archive/sf_${PV}.tar.gz -> ${P}.tar.gz"

for i in $NNUE_FILES; do
	SRC_URI+=" https://tests.stockfishchess.org/api/nn/${i} -> ${P}-${i}"
done

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~riscv x86"
IUSE="cpu_flags_arm_v7 cpu_flags_x86_avx2 cpu_flags_x86_popcnt cpu_flags_x86_sse cpu_flags_x86_avx512f
	cpu_flags_x86_avx512dq debug general-32 general-64 +optimize"

DEPEND="|| ( app-arch/unzip app-arch/zip )"

S="${WORKDIR}/Stockfish-sf_${PV}/src"

src_prepare() {
	default

	# remove config sanity check that doesn't like our COMPILER settings
	sed -i -e 's/ config-sanity//g' Makefile || die

	for i in $NNUE_FILES; do
		cp "${DISTDIR}"/${P}-${i} ${i} || die "copying the nnue file failed"
	done

	# prevent pre-stripping
	sed -e 's:-strip $(BINDIR)/$(EXE)::' -i Makefile \
		|| die 'failed to disable stripping in the Makefile'

	# Makefile is a bit optimistic
	sed -e 's:-flto=full:-flto:g' -i Makefile || die
}

src_compile() {
	local my_arch

	# generic unoptimized first
	use general-32 && my_arch=general-32
	use general-64 && my_arch=general-64

	# x86
	use x86 && my_arch=x86-32-old
	use cpu_flags_x86_sse && my_arch=x86-32

	# amd64
	use amd64 && my_arch=x86-64
	use cpu_flags_x86_popcnt && my_arch=x86-64-modern

	# both bmi2 and avx2 are part of hni (haswell new instructions)
	use cpu_flags_x86_avx2 && my_arch=x86-64-bmi2

	# avx512
	# we currently can't express  'avx512vnni' 'avx512dq' 'avx512f' 'avx512bw' 'avx512vl'
	# so only enable basic support
	use cpu_flags_x86_avx512f && use cpu_flags_x86_avx512dq && my_arch=x86-64-avx512

	# other architectures
	use cpu_flags_arm_v7 && my_arch=armv7
	use ppc && my_arch=ppc
	use ppc64 && my_arch=ppc64

	# There's a nice hack in the Makefile that overrides the value of CXX with
	# COMPILER to support Travis CI and we abuse it to make sure that we
	# build with our compiler of choice.
	emake profile-build ARCH="${my_arch}" \
		COMP="$(tc-getCXX)" \
		COMPILER="$(tc-getCXX)" \
		debug=$(usex debug "yes" "no") \
		optimize=$(usex optimize "yes" "no")
}

src_install() {
	dobin "${PN}"
	dodoc ../AUTHORS ../README.md
}
