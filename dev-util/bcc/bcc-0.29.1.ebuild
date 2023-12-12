# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{9..12} )
LLVM_MAX_SLOT=18

inherit cmake linux-info llvm lua-single python-r1 toolchain-funcs

DESCRIPTION="Tools for BPF-based Linux IO analysis, networking, monitoring, and more"
HOMEPAGE="https://iovisor.github.io/bcc/"
SRC_URI="https://github.com/iovisor/bcc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="+lua test"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	lua? ( ${LUA_REQUIRED_USE} )
"

# tests need root access
RESTRICT="test"

RDEPEND="
	>=dev-libs/elfutils-0.166:=
	>=dev-libs/libbpf-0.7.0:=[static-libs(-)]
	sys-kernel/linux-headers
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1)):=
	<sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):=[llvm_targets_BPF(+)]
	${PYTHON_DEPS}
	lua? ( ${LUA_DEPS} )
"
DEPEND="
	${RDEPEND}
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
	app-arch/zip
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/bcc-0.9.0-no-luajit-automagic-dep.patch"
	"${FILESDIR}/bcc-0.25.0-cmakelists.patch"
	"${FILESDIR}/bcc-0.23.0-man-compress.patch"
)

pkg_pretend() {
	local CONFIG_CHECK="~BPF ~BPF_SYSCALL ~NET_CLS_BPF ~NET_ACT_BPF
		~HAVE_EBPF_JIT ~BPF_EVENTS ~DEBUG_INFO ~FUNCTION_TRACER ~KALLSYMS_ALL
		~KPROBES"

	check_extra_config
}

pkg_setup() {
	llvm_pkg_setup
	python_setup
}

src_prepare() {
	local bpf_link_path

	# this avoids bundling
	bpf_link_path="$(realpath --relative-to="${S}/src/cc/libbpf" /usr/include/bpf)" || die
	ln -sfn "${bpf_link_path}" src/cc/libbpf/include || die

	# bug 811288
	local script scriptname
	for script in $(find tools/old -type f -name "*.py" || die); do
		scriptname=$(basename ${script} || die)
		mv ${script} tools/old/old-${scriptname} || die
	done

	cmake_src_prepare
}

python_add_impl() {
	bcc_python_impls+="${EPYTHON};"
}

src_configure() {
	local bcc_python_impls
	python_foreach_impl python_add_impl

	local mycmakeargs=(
		-DREVISION=${PV%%_*}
		-DENABLE_LLVM_SHARED=ON
		-DCMAKE_USE_LIBBPF_PACKAGE=ON
		-DLIBBPF_INCLUDE_DIRS="$($(tc-getPKG_CONFIG) --cflags-only-I libbpf | sed 's:-I::g')"
		-DKERNEL_INCLUDE_DIRS="${KERNEL_DIR}"
		-DPYTHON_CMD="${bcc_python_impls%;}"
		-Wno-dev
	)
	if use lua && use lua_single_target_luajit; then
		mycmakeargs+=( -DWITH_LUAJIT=1 )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	python_replicate_script $(grep -Flr '#!/usr/bin/python' "${ED}/usr/share/bcc/tools")
	python_foreach_impl python_optimize

	newenvd "${FILESDIR}"/60bcc.env 60bcc.env
	local -A rename_tools=(
		[trace]=1
	)

	local tool name
	for tool in "${ED}"/usr/share/bcc/tools/*; do
		[[ ! -x ${tool} && ! -L ${tool} || -d ${tool} ]] && continue
		name=${tool##*/}
		[[ -n ${rename_tools[${name}]} ]] && name=bcc-${name}
		dosym -r "${tool#${ED}}" /usr/sbin/${name}
	done

	docompress /usr/share/${PN}/man

	newenvd - "70${P}" <<-_EOF_
		MANPATH="${EPREFIX}/usr/share/${PN}/man"
	_EOF_
}
