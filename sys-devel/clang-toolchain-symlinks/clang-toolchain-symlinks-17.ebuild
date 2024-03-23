# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

DESCRIPTION="Symlinks to use Clang on GCC-free system"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~arm64-macos ~x64-macos"
IUSE="gcc-symlinks multilib-symlinks +native-symlinks"

# Blocker for bug #872416
RDEPEND="
	!<sys-devel/gcc-config-2.6
	sys-devel/clang:${SLOT}
"

src_install() {
	local tools=()

	if use native-symlinks; then
		tools+=(
			cc:clang
			cpp:clang-cpp
			c++:clang++
		)
	fi
	if use gcc-symlinks; then
		tools+=(
			gcc:clang
			g++:clang++
		)
	fi

	local chosts=( "${CHOST}" )
	if use multilib-symlinks; then
		local abi
		for abi in $(get_all_abis); do
			chosts+=( "$(get_abi_CHOST "${abi}")" )
		done
	fi

	local chost t
	local dest=/usr/lib/llvm/${SLOT}/bin
	dodir "${dest}"
	for t in "${tools[@]}"; do
		dosym "${t#*:}" "${dest}/${t%:*}"
	done
	for chost in "${chosts[@]}"; do
		for t in "${tools[@]}"; do
			dosym "${t#*:}" "${dest}/${chost}-${t%:*}"
		done
	done
}
