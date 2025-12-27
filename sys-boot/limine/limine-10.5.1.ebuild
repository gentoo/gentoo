# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {19..21} )
inherit llvm-r1

DESCRIPTION="Limine is a modern, advanced, and portable BIOS/UEFI multiprotocol bootloader"
HOMEPAGE="https://limine-bootloader.org/"
SRC_URI="https://codeberg.org/Limine/Limine/releases/download/v${PV}/limine-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bios +bios-pxe +bios-cd +uefi-cd +uefi-ia32 +uefi-x86-64 +uefi-aarch64 +uefi-riscv64 +uefi-loongarch64"

MY_LLVM_TARGETS="AArch64 ARM X86 RISCV LoongArch"
MY_LLVM_FLAGS="llvm_targets_${MY_LLVM_TARGETS// /(-),llvm_targets_}(-)"

BDEPEND="
	app-alternatives/gzip
	dev-lang/nasm
	sys-apps/findutils
	$(llvm_gen_dep "
		llvm-core/llvm:\${LLVM_SLOT}[${MY_LLVM_FLAGS}]
		llvm-core/clang:\${LLVM_SLOT}[${MY_LLVM_FLAGS}]
		llvm-core/lld:\${LLVM_SLOT}
	")
	uefi-cd? ( sys-fs/mtools )
"

src_configure() {
	local myconf=(
		"$(use_enable bios)"
		"$(use_enable bios-cd)"
		"$(use_enable bios-pxe)"

		"$(use_enable uefi-ia32)"
		"$(use_enable uefi-x86-64)"
		"$(use_enable uefi-aarch64)"
		"$(use_enable uefi-riscv64)"
		"$(use_enable uefi-loongarch64)"
		"$(use_enable uefi-cd)"
	)

	econf "${myconf[@]}"
}
