# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Free UCI chess engine, claimed to be the strongest in the world"
HOMEPAGE="http://stockfishchess.org/"

SRC_URI="https://stockfish.s3.amazonaws.com/${P}-src.zip"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="armv7 cpu_flags_x86_avx2 cpu_flags_x86_popcnt cpu_flags_x86_sse debug
	general-32 general-64 +optimize"

DEPEND="|| ( app-arch/unzip	app-arch/zip )"
RDEPEND=""

S="${WORKDIR}/src"

src_prepare() {
	default

	# prevent pre-stripping
	sed -e 's:-strip $(BINDIR)/$(EXE)::' -i Makefile \
		|| die 'failed to disable stripping in the Makefile'
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

	# other architectures
	use armv7 && my_arch=armv7
	use ppc && my_arch=ppc
	use ppc64 && my_arch=ppc64

	# Skip the "build" target and use "all" instead to avoid the config
	# sanity check (which would throw a fit about our compiler). There's
	# a nice hack in the Makefile that overrides the value of CXX with
	# COMPILER to support Travis CI and we abuse it to make sure that we
	# build with our compiler of choice.
	emake all ARCH="${my_arch}" \
		COMP=$(tc-getCXX) \
		COMPILER=$(tc-getCXX) \
		debug=$(usex debug "yes" "no") \
		optimize=$(usex optimize "yes" "no")
}

src_install() {
	dobin "${PN}"
	dodoc ../AUTHORS ../Readme.md
}
