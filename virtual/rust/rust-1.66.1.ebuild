# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for Rust language compiler"

LICENSE=""

# adjust when rust upstream bumps internal llvm
# we do not allow multiple llvm versions in dev-lang/rust for
# neither system nor bundled, so we just hardcode it here.
SLOT="0/llvm-15"
KEYWORDS="amd64 arm arm64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="rustfmt"

BDEPEND=""
RDEPEND="|| (
	~dev-lang/rust-${PV}[rustfmt?,${MULTILIB_USEDEP}]
	~dev-lang/rust-bin-${PV}[rustfmt?,${MULTILIB_USEDEP}]
)"
