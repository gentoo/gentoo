# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for Rust language compiler"

LICENSE=""

# adjust when rust upstream bumps internal llvm
# we do not allow multiple llvm versions in dev-lang/rust for
# neither system nor bundled, so we just hardcode it here.
SLOT="0/llvm-16"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="profiler rustfmt"

BDEPEND=""
RDEPEND="|| (
	~dev-lang/rust-bin-${PV}[profiler(-)?,rustfmt?,${MULTILIB_USEDEP}]
	~dev-lang/rust-${PV}[profiler(-)?,rustfmt?,${MULTILIB_USEDEP}]
)"
