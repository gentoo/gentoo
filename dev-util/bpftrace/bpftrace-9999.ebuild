# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs linux-info cmake-utils

DESCRIPTION="High-level tracing language for eBPF"
HOMEPAGE="https://github.com/iovisor/bpftrace"

if [[ ${PV} =~ 9{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/iovisor/${PN}"
	BDEPEND=""
else
	SRC_URI="https://github.com/iovisor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	BDEPEND="app-arch/xz-utils "
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

COMMON_DEPEND="sys-devel/clang:=
	dev-libs/libbpf:=
	>=sys-devel/llvm-3.7.1:=[llvm_targets_BPF(+)]
	>=dev-util/bcc-0.9.0:=
	virtual/libelf"
DEPEND="${COMMON_DEPEND}
	test? ( dev-cpp/gtest )"
RDEPEND="${COMMON_DEPEND}"
BDEPEND+="dev-util/cmake
	sys-devel/flex
	sys-devel/bison"

QA_DT_NEEDED="/usr/lib.*/libbpftraceresources.so"

PATCHES=(
	"${FILESDIR}/bpftrace-0.9_pre20190311-install-libs.patch"
	"${FILESDIR}/bpftrace-mandir.patch"
	"${FILESDIR}/bpftrace-0.9-llvm-8.patch"
)

# lots of fixing needed
RESTRICT="test"

pkg_pretend() {
	local CONFIG_CHECK="~BPF ~BPF_SYSCALL ~BPF_JIT ~BPF_EVENTS"

	check_extra_config
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local -a mycmakeargs
	mycmakeargs=(
		"-DSTATIC_LINKING:BOOL=OFF"
		"-DBUILD_TESTING:BOOL=OFF"
	)

	cmake-utils_src_configure
}
