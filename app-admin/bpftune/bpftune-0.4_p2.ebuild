# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {11..21} )

inherit toolchain-funcs llvm-r2

MY_PV=${PV/_p/-}
MY_P=${PN}-${MY_PV}
DESCRIPTION="BPF driven auto-tuning"
HOMEPAGE="https://github.com/oracle/bpftune"
SRC_URI="https://github.com/oracle/bpftune/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="~amd64"

# tests need root
RESTRICT="test"

DEPEND="
	dev-libs/libbpf:=
	sys-libs/libcap:=
	dev-util/bpftool
	dev-libs/libnl:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
"

PATCHES=(
	"${FILESDIR}/bpftune-0.4_p2-cflags.patch"
)

src_compile() {
	emake CC="$(tc-getCC)" CLANG="${CHOST}-clang"
}
