# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bayesian Inference of Phylogeny"
HOMEPAGE="https://nbisweden.github.io/MrBayes/"
SRC_URI="https://github.com/NBISweden/MrBayes/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mpi readline"
# --with-readline was given, but MPI support requires readline to be disabled.
REQUIRED_USE="mpi? ( !readline )"

DEPEND="
	sys-libs/ncurses:=
	mpi? ( virtual/mpi )
	readline? ( sys-libs/readline:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		"$(use_with mpi)" \
		"$(use_with readline)" \
		"$(use_enable debug )" \
		# configure checks cpuid and enables fma{3,4}, sse{1..4} if detected.
		# Configure options only allow disabling the auto-detection, but do not
		# actually allow toggling the individual cpu instruction sets. The only
		# way to guarantee that cross-compiling and binpkgs will work on machines
		# other than the host is to unconditionally disable sse/fma/avx.
		#"$(use_enable cpu_flags_x86_sse sse )" \
		#"$(use_enable cpu_flags_x86_avx avx )" \
		#"$(use_enable cpu_flags_x86_fma3 fma )" \
		# Has optional support for sci-biology/beagle::science
		# "$(use_with beagle)"
}

src_compile() {
	# The --disable options for the cpu instruction sets don't actually work so
	# we override it here and also set the user specified CFLAGS.
	emake SIMD_FLAGS= CPUEXT_FLAGS= CFLAGS="${CFLAGS}"
}
