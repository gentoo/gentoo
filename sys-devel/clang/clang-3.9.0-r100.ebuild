# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib-build

DESCRIPTION="C language family frontend for LLVM (meta-ebuild)"
HOMEPAGE="http://clang.llvm.org/"
SRC_URI=""

# Keep in sync with sys-devel/llvm
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Mips MSP430
	NVPTX PowerPC Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

LICENSE="UoI-NCSA"
# keep in sync with sys-devel/llvm!
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="debug multitarget python +static-analyzer ${ALL_LLVM_TARGETS[*]}"

RDEPEND="~sys-devel/llvm-${PV}[clang(-),debug=,python?,static-analyzer?,${LLVM_TARGET_USEDEPS// /,},${MULTILIB_USEDEP}]"

REQUIRED_USE="
	|| ( ${ALL_LLVM_TARGETS[*]} )
	multitarget? ( ${ALL_LLVM_TARGETS[*]} )"

# Please keep this package around since it's quite likely that we'll
# return to separate LLVM & clang ebuilds when the cmake build system
# is complete.

pkg_postinst() {
	if has_version ">=dev-util/ccache-3.1.9-r2" ; then
		#add ccache links as clang might get installed after ccache
		"${EROOT}"/usr/bin/ccache-config --install-links
	fi
}

pkg_postrm() {
	if has_version ">=dev-util/ccache-3.1.9-r2" && [[ -z ${REPLACED_BY_VERSION} ]]; then
		# --remove-links would remove all links, --install-links updates them
		"${EROOT}"/usr/bin/ccache-config --install-links
	fi
}
