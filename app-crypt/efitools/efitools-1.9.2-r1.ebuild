# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tools for manipulating UEFI secure boot platforms"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/efitools.git"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="static"

LIB_DEPEND="dev-libs/openssl:=[static-libs(+)]"

RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	sys-boot/gnu-efi"
BDEPEND="
	app-crypt/sbsigntools
	dev-perl/File-Slurp
	sys-apps/help2man
	sys-devel/binutils
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/1.9.2-clang16.patch
	"${FILESDIR}"/1.9.2-Makefile.patch
	"${FILESDIR}"/1.9.2-gcc15.patch
	"${FILESDIR}"/1.9.2-fix-binutils-2.46.patch
)

check_and_set_objcopy() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		# bug #931792
		# llvm-objcopy does not support EFI target, try to use binutils objcopy or fail
		tc-export OBJCOPY
		OBJCOPY="${OBJCOPY/llvm-/}"
		# Test OBJCOPY to see if it supports EFI targets, and return if it does
		LC_ALL=C "${OBJCOPY}" --help | grep -q '\<pei-' && return 0
		# If OBJCOPY does not support EFI targets, it is possible that the 'objcopy' on our path is
		# still LLVM if the 'binutils-plugin' USE flag is set. In this case, we check to see if the
		# '(prefix)/usr/bin/objcopy' binary is available (it should be, it's a dependency), and if
		# so, we use the absolute path explicitly.
		local binutils_objcopy="${EPREFIX}"/usr/bin/"${OBJCOPY}"
		if [[ -e "${binutils_objcopy}" ]]; then
			OBJCOPY="${binutils_objcopy}"
		fi
		if ! use arm && ! use riscv; then
			# bug #939338
			# objcopy does not understand PE/COFF on these arches: arm32, riscv64 and mips64le
			# gnu-efi contains a workaround
			LC_ALL=C "${OBJCOPY}" --help | grep -q '\<pei-' || die "${OBJCOPY} (objcopy) does not support EFI target"
		fi
	fi
}

pkg_setup() {
	check_and_set_objcopy
}

src_prepare() {
	default

	# Let it build with clang
	if tc-is-clang; then
		sed -i -e 's/-fno-toplevel-reorder//g' Make.rules || die
	fi

	if tc-ld-is-lld; then
		tc-ld-force-bfd
	fi

	if use static; then
		append-ldflags -static
		export STATIC_FLAG=--static
	fi
}

src_configure() {
	# Calls LD directly, doesn't respect LDFLAGS. Low level package anyway.
	# See bug #908813.
	filter-lto

	tc-export AR CC LD NM OBJCOPY PKG_CONFIG
}
