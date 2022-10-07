# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit estack linux-info optfeature python-any-r1 toolchain-funcs

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-pre/-git}"

DESCRIPTION="Tool for inspection and simple manipulation of eBPF programs and maps"
HOMEPAGE="https://kernel.org/"

LINUX_V="${PV:0:1}.x"
LINUX_VER=$(ver_cut 1-2)
LINUX_PATCH=patch-${PV}.xz
SRC_URI="https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_PATCH}"

LINUX_SOURCES="linux-${LINUX_VER}.tar.xz"
SRC_URI+=" https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"

SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/dev-util/perf/perf-5.19-binutils-2.39-patches.tar.xz"

S_K="${WORKDIR}/linux-${LINUX_VER}"
S="${S_K}/tools/bpf/bpftool"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="caps"

RDEPEND="
	sys-libs/binutils-libs:=
	sys-libs/zlib:=
	virtual/libelf:=
	caps? ( sys-libs/libcap:= )
"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-5.8
"
BDEPEND="
	${LINUX_PATCH+dev-util/patchutils}
	${PYTHON_DEPS}
	dev-python/docutils
"

CONFIG_CHECK="~DEBUG_INFO_BTF"

# src_unpack and src_prepare are copied from dev-util/perf since
# it's building from the same tarball, please keep it in sync with perf
src_unpack() {
	local paths=(
		tools/bpf kernel/bpf
		tools/{arch,build,include,lib,perf,scripts} {scripts,include,lib} "arch/*/lib"
	)

	# We expect the tar implementation to support the -j option (both
	# GNU tar and libarchive's tar support that).
	echo ">>> Unpacking ${LINUX_SOURCES} (${paths[*]}) to ${PWD}"
	tar --wildcards -xpf "${DISTDIR}"/${LINUX_SOURCES} \
		"${paths[@]/#/linux-${LINUX_VER}/}" || die

	if [[ -n ${LINUX_PATCH} ]] ; then
		eshopts_push -o noglob
		ebegin "Filtering partial source patch"
		filterdiff -p1 ${paths[@]/#/-i } -z "${DISTDIR}"/${LINUX_PATCH} \
			> ${P}.patch
		eend $? || die "filterdiff failed"
		eshopts_pop
	fi

	local a
	for a in ${A}; do
		[[ ${a} == ${LINUX_SOURCES} ]] && continue
		[[ ${a} == ${LINUX_PATCH} ]] && continue
		unpack ${a}
	done
}

src_prepare() {
	default

	if [[ -n ${LINUX_PATCH} ]] ; then
		pushd "${S_K}" >/dev/null || die
		eapply "${WORKDIR}"/${P}.patch
		popd || die
	fi

	pushd "${S_K}" >/dev/null || die
	# Used `git format-patch 00b32625982e0c796f0abb8effcac9c05ef55bd3...600b7b26c07a070d0153daa76b3806c1e52c9e00`
	# bug #868123
	eapply "${WORKDIR}"/perf-5.19-binutils-2.39-patches
	popd || die

	# dev-python/docutils installs rst2man.py, not rst2man
	sed -i -e 's/rst2man/rst2man.py/g' Documentation/Makefile || die
}

bpftool_make() {
	local arch=$(tc-arch-kernel)
	tc-export AR CC LD

	emake V=1 VF=1 \
		HOSTCC="$(tc-getBUILD_CC)" HOSTLD="$(tc-getBUILD_LD)" \
		EXTRA_CFLAGS="${CFLAGS}" ARCH="${arch}" BPFTOOL_VERSION="${MY_PV}" \
		prefix="${EPREFIX}"/usr \
		feature-libcap="$(usex caps 1 0)" \
		"$@"
}

src_compile() {
	bpftool_make
	bpftool_make -C Documentation
}

src_install() {
	bpftool_make DESTDIR="${D}" install
	bpftool_make mandir="${ED}"/usr/share/man -C Documentation install
}

pkg_postinst() {
	optfeature "clang-bpf-co-re support" sys-devel/clang[llvm_targets_BPF]
}
