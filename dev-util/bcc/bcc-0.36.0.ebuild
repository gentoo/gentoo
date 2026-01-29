# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{{11..14},{13..14}t}  )
LLVM_COMPAT=( {15..21} )

inherit cmake linux-info llvm-r1 lua-single distutils-r1 toolchain-funcs

DESCRIPTION="Tools for BPF-based Linux IO analysis, networking, monitoring, and more"
HOMEPAGE="https://iovisor.github.io/bcc/"
SRC_URI="https://github.com/iovisor/bcc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="debuginfod +lua lzma +python static-libs test"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	lua? ( python ${LUA_REQUIRED_USE} )
"

# tests need root access
RESTRICT="test"

RDEPEND="
	app-arch/zstd:=
	>=dev-libs/elfutils-0.166:=[debuginfod?]
	dev-libs/libbpf:=
	dev-libs/libffi:=
	sys-kernel/linux-headers
	sys-libs/ncurses:=[tinfo]
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
	lzma? ( || (
		app-arch/xz-utils
		app-arch/lzma
	) )
	python? ( ${PYTHON_DEPS} )
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
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig
	python? ( ${DISTUTILS_DEPS} )
"

PATCHES=(
	"${FILESDIR}/bcc-0.9.0-no-luajit-automagic-dep.patch"
	"${FILESDIR}/bcc-0.25.0-cmakelists.patch"
	"${FILESDIR}/bcc-0.23.0-man-compress.patch"
	"${FILESDIR}/bcc-0.31.0-no-automagic-deps.patch"
)

pkg_pretend() {
	local CONFIG_CHECK="~BPF ~BPF_SYSCALL ~NET_CLS_BPF ~NET_ACT_BPF
		~HAVE_EBPF_JIT ~BPF_EVENTS ~DEBUG_INFO ~FUNCTION_TRACER ~KALLSYMS_ALL
		~KPROBES"

	check_extra_config
}

pkg_setup() {
	llvm-r1_pkg_setup
	use python && python_setup
}

bcc_distutils_phase() {
	if use python; then
		local python_phase_func="distutils-r1_${EBUILD_PHASE_FUNC}"

		if declare -f "${python_phase_func}" > /dev/null; then
			pushd "${S}/src/python" > /dev/null || die
			MY_S="${S}" S="${S}/src/python" "${python_phase_func}"
			popd > /dev/null || die
		else
			die "Called ${FUNCNAME[0]} called in ${EBUILD_PHASE_FUNC}, but ${python_phase_func} doesn't exist"
		fi
	fi
}

src_prepare() {
	local bpf_link_path

	# this avoids bundling
	bpf_link_path="$(realpath --relative-to="${S}/src/cc/libbpf" /usr/include/bpf)" || die
	ln -sfn "${bpf_link_path}" src/cc/libbpf/include || die

	# bug 811288
	local script scriptname
	for script in $(find tools/old -type f -name "*.py" || die); do
		mv "${script}" "tools/old/old-${script##*/}" || die
	done

	sed -i '/#include <error.h>/d' examples/cpp/KModRetExample.cc || die

	use static-libs || PATCHES+=( "${FILESDIR}/bcc-0.31.0-dont-install-static-libs.patch" )

	# use distutils-r1 eclass funcs rather than letting upstream handle python
	printf '\n' > src/python/CMakeLists.txt || die

	if use python; then
		for python_file in $(find "${S}/src/python" -name '*.py.in' || die); do
			sed "s:@REVISION@:${PV%%_*}:" "${python_file}" > "${python_file%.in}" || die
		done
	fi

	cmake_src_prepare
	bcc_distutils_phase
}

src_configure() {
	local mycmakeargs=(
		-DREVISION=${PV%%_*}
		-DENABLE_LIBDEBUGINFOD=$(usex debuginfod)
		-DENABLE_LLVM_SHARED=ON
		-DENABLE_NO_PIE=OFF
		-DWITH_LZMA=$(usex lzma)
		-DCMAKE_USE_LIBBPF_PACKAGE=ON
		-DLIBBPF_INCLUDE_DIRS="$($(tc-getPKG_CONFIG) --cflags-only-I libbpf | sed 's:-I::g')"
		-DKERNEL_INCLUDE_DIRS="${KERNEL_DIR}"
		-DNO_BLAZESYM=ON
		-Wno-dev
	)
	if use lua && use lua_single_target_luajit; then
		mycmakeargs+=( -DWITH_LUAJIT=ON )
	fi

	cmake_src_configure
	bcc_distutils_phase
}

src_compile() {
	cmake_src_compile
	bcc_distutils_phase
}

bcc_tool_name() {
	local -A rename_tools=(
		[trace]=1
		[profile]=1
		[inject]=1
		[capable]=1
	)

	local name="${1}"

	local name="${name##*/}"
	name="${name%.py}"

	[[ -n ${rename_tools[${name}]} ]] && name=bcc-${name}

	printf -- '%s\n' "${name}"
}

python_install() {
	distutils-r1_python_install

	python_scriptinto /usr/sbin

	local tool
	for tool in $(grep -Elr '#!/usr/bin/(env |)python' "${MY_S}/tools"); do
		python_newscript "${tool}" "$(bcc_tool_name "${tool}")"
	done
}

src_install() {
	cmake_src_install
	bcc_distutils_phase

	newenvd "${FILESDIR}"/60bcc.env 60bcc.env

	local tool target
	for tool in "${ED}"/usr/share/bcc/tools/*; do
		[[ -d ${tool} || ! -x ${tool} || ${tool} =~ .*[.](c|txt) ]] && continue
		grep -qE '^#!/usr/bin/(env |)python' "${tool}" && continue
		sed -e 's:dirname \$0:dirname "$(realpath "$0")":' -i "${tool}" || die

		target="/usr/sbin/$(bcc_tool_name "${tool}")"
		[[ -e ${ED}${target} ]] && continue

		dosym -r "${tool#${ED}}" "${target}"
	done

	docompress /usr/share/${PN}/man

	newenvd - "70${P}" <<-_EOF_
		MANPATH="${EPREFIX}/usr/share/${PN}/man"
	_EOF_
}
