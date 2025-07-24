# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {15..20} )
LLVM_OPTIONAL=1
PYTHON_COMPAT=( python3_{11..14} )

inherit bash-completion-r1 linux-info llvm-r1 python-any-r1 toolchain-funcs

DESCRIPTION="Tool for inspection and simple manipulation of eBPF programs and maps"
HOMEPAGE="https://github.com/libbpf/bpftool"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libbpf/bpftool.git"
	EGIT_SUBMODULES=(libbpf)
else
	# bpftool typically vendors whatever libbpf is current at the time
	# of a release, while libbpf publishes minor updates more frequently.
	# Uncomment the following to bundle an updated libbpf e.g. in case of
	# security or crasher bugs in libbpf and to keep the two synchronized.
	# This allows us to quickly update the vendored lib with a revbump.
	# Currently bpftool-x.y vendors libbpf-1.y; DO NOT mix different y versions.
	# See the libbpf repo (https://github.com/libbpf/libbpf) for possible updates.
	# LIBBPF_VERSION=1.5.0

	if [[ ! -z ${LIBBPF_VERSION} ]] ; then
		SRC_URI="https://github.com/libbpf/bpftool/archive/refs/tags/v${PV}.tar.gz -> bpftool-${PV}.tar.gz
			https://github.com/libbpf/libbpf/archive/refs/tags/v${LIBBPF_VERSION}.tar.gz
			  -> libbpf-${LIBBPF_VERSION}.tar.gz"
	else
		# use tarball with bundled libbpf
		SRC_URI="https://github.com/libbpf/bpftool/releases/download/v${PV}/bpftool-libbpf-v${PV}-sources.tar.gz"
		S="${WORKDIR}/bpftool-libbpf-v${PV}-sources"
	fi

	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"
IUSE="caps +clang llvm"
REQUIRED_USE="llvm? ( ${LLVM_REQUIRED_USE} )"

RDEPEND="
	caps? ( sys-libs/libcap:= )
	llvm? ( $(llvm_gen_dep 'llvm-core/llvm:${LLVM_SLOT}') )
	!llvm? ( sys-libs/binutils-libs:= )
	sys-libs/zlib:=
	virtual/libelf:=
"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-5.8
"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/tar
	dev-python/docutils
	clang? ( $(llvm_gen_dep 'llvm-core/clang:${LLVM_SLOT}[llvm_targets_BPF]') )
	!clang? ( sys-devel/bpf-toolchain )
"

CONFIG_CHECK="~DEBUG_INFO_BTF"

pkg_setup() {
	python-any-r1_pkg_setup
	use llvm && llvm-r1_pkg_setup
}

src_prepare() {
	default

	# prepare libbpf if necessary
	if [[ ! -z ${LIBBPF_VERSION} ]] ; then
		rm -rf libbpf || die
		ln -s "${WORKDIR}/libbpf-${LIBBPF_VERSION}" libbpf || die
	fi

	# remove -Werror from libbpf (bug 887981)
	sed -i -e 's/\-Werror//g' libbpf/src/Makefile || die

	# remove -Werror from bpftool feature detection
	sed -i -e 's/-Werror//g' src/Makefile.feature || die

	# remove hardcoded/unhelpful flags from bpftool
	sed -i -e '/CFLAGS += -O2/d' -e 's/-W //g' -e 's/-Wextra //g' src/Makefile || die

	# always build bpf bits with std=gnu11 for kernel compatibility (bug 955156)
	sed -i 's/-fno-stack-protector/& -std=gnu11/g' src/Makefile || die

	if ! use clang; then
		# make people aware of what they are doing
		ewarn "Using bpf-toolchain instead of clang due to USE=-clang."
		ewarn "Please report any odd behaviours you observe, since using gcc for BPF"
		ewarn "is still under development in both the Linux kernel and gcc itself."

		# prevent attribute warning about preserve_access_index
		# since gcc does not support '#pragma clang attribute push':
		# https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=675b4e2
		sed -i 's/std=gnu11/& -DBPF_NO_PRESERVE_ACCESS_INDEX/g' src/Makefile || die

		# remove bpf target & add assembly annotations to fix CO-RE feature detection
		sed -i -e 's/-target bpf/-dA/' src/Makefile.feature || die

		# remove bpf target from skeleton build
		sed -i -e 's/--target=bpf//g' src/Makefile || die
	fi

	# Use rst2man or rst2man.py depending on which one exists (#930076)
	type -P rst2man >/dev/null || sed -i -e 's/rst2man/rst2man.py/g' docs/Makefile || die
}

bpftool_make() {
	# which BPF compiler should we use?
	if use clang; then
		export CLANG="$(get_llvm_prefix -b)/bin/clang"
		export LLVM_STRIP="$(get_llvm_prefix -b)/bin/llvm-strip"
	else
		# use bpf-toolchain
		export CLANG="bpf-unknown-none-gcc"
		export LLVM_STRIP="bpf-unknown-none-strip"
	fi

	tc-export AR CC LD

	emake \
		ARCH="$(tc-arch-kernel)" \
		HOSTAR="$(tc-getBUILD_AR)" \
		HOSTCC="$(tc-getBUILD_CC)" \
		HOSTLD="$(tc-getBUILD_LD)" \
		bash_compdir="$(get_bashcompdir)" \
		feature-libcap="$(usex caps 1 0)" \
		feature-llvm="$(usex llvm 1 0)" \
		prefix="${EPREFIX}"/usr \
		V=1 \
		"$@"
}

src_compile() {
	bpftool_make -C src
	bpftool_make -C docs
}

src_install() {
	bpftool_make DESTDIR="${D}" -C src install
	bpftool_make mandir="${ED}"/usr/share/man -C docs install
}
