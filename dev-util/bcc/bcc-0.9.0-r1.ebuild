# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cmake-utils linux-info python-single-r1

DESCRIPTION="Tools for BPF-based Linux IO analysis, networking, monitoring, and more"
HOMEPAGE="https://iovisor.github.io/bcc/"
EGIT_COMMIT="v${PV}"
SRC_URI="https://github.com/iovisor/bcc/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/bcc-0.9.0-linux-5-bpf.patch.xz"
RESTRICT="test"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+luajit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-libs/libbpf:=
	>=sys-kernel/linux-headers-4.18
	>=dev-libs/elfutils-0.166:=
	sys-devel/clang:=
	>=sys-devel/llvm-3.7.1:=[llvm_targets_BPF(+)]
	luajit? ( dev-lang/luajit )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/cmake
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-${EGIT_COMMIT#v}

PATCHES=(
	"${FILESDIR}/bcc-0.9.0-system-libbpf.patch"
	"${FILESDIR}/bcc-0.9.0-no-luajit-automagic-dep.patch"
)

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
	# needs bpf.h from linux-5.0 to build
	has_version '>=sys-kernel/linux-headers-5.0' || \
		eapply "${WORKDIR}/bcc-0.9.0-linux-5-bpf.patch"

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
}
