# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cmake-utils linux-info python-single-r1

EGIT_COMMIT="v${PV}"
LIBBPF_VER="0.0.6"

DESCRIPTION="Tools for BPF-based Linux IO analysis, networking, monitoring, and more"
HOMEPAGE="https://iovisor.github.io/bcc/"

# This bundles libbpf, I tried to unbundle it, but I am not good enough
# with cmake to do it. Patches accepted...
SRC_URI="https://github.com/iovisor/bcc/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/libbpf/libbpf/archive/v${LIBBPF_VER}.tar.gz -> libbpf-${LIBBPF_VER}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+luajit test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=sys-kernel/linux-headers-4.14
	>=dev-libs/elfutils-0.166:=
	sys-devel/clang:=
	>=sys-devel/llvm-3.7.1:=[llvm_targets_BPF(+)]
	luajit? ( dev-lang/luajit )
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	test? (
		|| (
			net-misc/iputils[arping]
			net-analyzer/arping
		)
		net-analyzer/netperf
		net-misc/iperf:*
	)
"
BDEPEND="
	dev-util/cmake
	virtual/pkgconfig
"

S=${WORKDIR}/${PN}-${EGIT_COMMIT#v}

PATCHES=(
	"${FILESDIR}/bcc-0.9.0-no-luajit-automagic-dep.patch"
)

# tests need root access
RESTRICT="test"

pkg_pretend() {
	local CONFIG_CHECK="~BPF ~BPF_SYSCALL ~NET_CLS_BPF ~NET_ACT_BPF
		~BPF_JIT ~BPF_EVENTS ~DEBUG_INFO ~FUNCTION_TRACER ~KALLSYMS_ALL
		~KPROBES"

	check_extra_config
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	rmdir src/cc/libbpf || die
	mv "${WORKDIR}"/libbpf-${LIBBPF_VER} src/cc/libbpf || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DREVISION=${PV%%_*}
		$(usex luajit '-DWITH_LUAJIT=1' '' '' '')
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED}"
	python_optimize
}
