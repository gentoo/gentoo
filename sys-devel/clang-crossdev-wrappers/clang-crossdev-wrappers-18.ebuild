# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Symlinks to a Clang crosscompiler"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~arm64-macos ~x64-macos"

RDEPEND="
	sys-devel/clang:${SLOT}
	sys-devel/lld:${SLOT}
"

src_install() {
	local llvm_path="${EPREFIX}/usr/lib/llvm/${SLOT}"
	into "${llvm_path}"

	for exe in "clang" "clang++" "clang-cpp"; do
		newbin - "${CTARGET}-${exe}" <<-EOF
		#!/bin/sh
		exec ${exe}-${SLOT} --no-default-config --config="/etc/clang/cross/${CTARGET}.cfg" \${@}
		EOF
	done

	local tools=(
		${CTARGET}-clang-${SLOT}:${CTARGET}-clang
		${CTARGET}-clang-cpp-${SLOT}:${CTARGET}-clang-cpp
		${CTARGET}-clang++-${SLOT}:${CTARGET}-clang++
	)

	local t
	for t in "${tools[@]}"; do
		dosym "${t#*:}" "${llvm_path}/bin/${t%:*}"
	done
}
