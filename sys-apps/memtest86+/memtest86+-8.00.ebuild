# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mount-boot secureboot toolchain-funcs

MY_PV=${PV/_/-}

DESCRIPTION="Memory tester based on PCMemTest"
HOMEPAGE="https://www.memtest.org/"
SRC_URI="https://github.com/memtest86plus/memtest86plus/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"

S=${WORKDIR}/memtest86plus-${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bios32 bios64 +boot uefi32 uefi64 iso32 iso64"

ISODEPS="
	dev-libs/libisoburn
	sys-fs/dosfstools
	sys-fs/mtools
"
BDEPEND="
	iso32? ( ${ISODEPS} )
	iso64? ( ${ISODEPS} )
	sys-devel/gcc:*
"

pkg_setup() {
	if use uefi32 || use uefi64; then
		secureboot_pkg_setup
	fi
}

src_prepare() {
	sed -i \
		-e 's#/sbin/mkdosfs#mkfs.vfat#' \
		-e 's/shell size/shell $(SIZE)/' \
		build/{i586,x86_64,loongarch64}/Makefile || die

	if ! tc-is-gcc; then
		ewarn "clang doesn't support indirect goto in function with no address-of-label expressions"
		ewarn "Ignoring CC=$(tc-getCC) and forcing ${CHOST}-gcc"
		export CC=${CHOST}-gcc AR=${CHOST}-gcc-ar
		tc-is-gcc || die "tc-is-gcc failed in spite of CC=${CC}"
	fi

	default
}

src_compile() {
	tc-export OBJCOPY
	export SIZE=$(tc-getPROG SIZE size)

	if use loong; then
		# a different build directory has to be selected for loong, and
		# there's no "BIOS" support.
		pushd build/loongarch64
			use uefi64 && emake mt86plus
			use iso64 && emake iso
		popd
		return
	fi

	pushd build/i586
		use bios32 || use uefi32 && emake mt86plus
		use iso32 && emake iso
	popd

	pushd build/x86_64
		use bios64 || use uefi64 && emake mt86plus
		use iso64 && emake iso
	popd
}

install_memtest_images() {
	if use loong; then
		use uefi64 && newins build/loongarch64/mt86plus memtest.loongarch64
		return
	fi

	use bios32 || use uefi32 && newins build/i586/mt86plus memtest.i586
	use bios64 || use uefi64 && newins build/x86_64/mt86plus memtest.x86_64
}

src_install() {
	default
	if use boot; then
		exeinto /etc/grub.d/
		newexe "${FILESDIR}"/39_memtest86+-r3 39_memtest86+
		insinto /boot/memtest86plus
		install_memtest_images
	fi

	insinto /usr/share/${PN}
	install_memtest_images
	if use loong; then
		use iso64 && newins build/loongarch64/memtest.iso memtest64.iso
	else
		use iso32 && newins build/i586/memtest.iso memtest.i586.iso
		use iso64 && newins build/x86_64/memtest.iso memtest.x86_64.iso
	fi

	if use uefi32 || use uefi64; then
		secureboot_auto_sign --in-place
	fi
}

pkg_pretend() {
	use boot && mount-boot_pkg_pretend
}

pkg_preinst() {
	use boot && mount-boot_pkg_preinst
}

pkg_prerm() {
	use boot && mount-boot_pkg_prerm
}
