# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cmake linux-info llvm python-r1

DESCRIPTION="Tools for BPF-based Linux IO analysis, networking, monitoring, and more"
HOMEPAGE="https://iovisor.github.io/bcc/"

SRC_URI="https://github.com/iovisor/bcc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+luajit test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-libs/libbpf-0.1.0-r1[static-libs(-)]
	>=sys-kernel/linux-headers-4.14
	>=dev-libs/elfutils-0.166:=
	sys-devel/clang:=
	sys-devel/llvm:=[llvm_targets_BPF(+)]
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

PATCHES=(
	"${FILESDIR}/bcc-0.9.0-no-luajit-automagic-dep.patch"
	"${FILESDIR}/bcc-0.14.0-cmakelists.patch"
)

# tests need root access
RESTRICT="test"

pkg_pretend() {
	local CONFIG_CHECK="~BPF ~BPF_SYSCALL ~NET_CLS_BPF ~NET_ACT_BPF
		~HAVE_BPF_JIT ~BPF_EVENTS ~DEBUG_INFO ~FUNCTION_TRACER ~KALLSYMS_ALL
		~KPROBES"

	check_extra_config
}

pkg_setup() {
	LLVM_MAX_SLOT=11 llvm_pkg_setup
	python_setup
}

src_prepare() {
	local bpf_link_path

	# this avoids bundling
	bpf_link_path="$(realpath --relative-to="${S}/src/cc/libbpf" /usr/include/bpf)" || die
	ln -sfn "${bpf_link_path}" src/cc/libbpf/include || die

	cmake_src_prepare
}

python_add_impl() {
	bcc_python_impls+="${EPYTHON};"
}

src_configure() {
	local bcc_python_impls
	python_foreach_impl python_add_impl

	local -a mycmakeargs=(
		-DREVISION=${PV%%_*}
		-DENABLE_LLVM_SHARED=ON
		-DCMAKE_USE_LIBBPF_PACKAGE=ON
		-DPYTHON_CMD="${bcc_python_impls%;}"
		$(usex luajit '-DWITH_LUAJIT=1')
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_foreach_impl python_optimize
	python_replicate_script $(grep -Flr '#!/usr/bin/python' "${ED}/usr/share/bcc/tools")
}
