# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mount-boot toolchain-funcs

MY_PV=${PV/_/-}

DESCRIPTION="Memory tester based on PCMemTest"
HOMEPAGE="https://www.memtest.org/"
SRC_URI="https://github.com/memtest86plus/memtest86plus/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bios32 bios64 +boot efi32 efi64 iso32 iso64"

ISODEPS="
	dev-libs/libisoburn
	sys-fs/dosfstools
	sys-fs/mtools
"
BDEPEND="
	iso32? ( ${ISODEPS} )
	iso64? ( ${ISODEPS} )
"

S=${WORKDIR}/memtest86plus-${MY_PV}

src_prepare() {
	sed -i \
		-e 's#/sbin/mkdosfs#mkfs.vfat#' \
		-e 's/^AS = as/AS +=/' \
		-e '/^CC/d' \
		-e 's/objcopy/$(OBJCOPY)/' \
		-e 's/shell size/shell $(SIZE)/' \
		build{32,64}/Makefile || die
	default
}

src_compile() {
	tc-export OBJCOPY
	export SIZE=$(tc-getPROG SIZE size)
	pushd build32
		use bios32 && emake memtest.bin
		use efi32 && emake memtest.efi
		use iso32 && emake iso
	popd

	pushd build64
		use bios64 && emake memtest.bin
		use efi64 && emake memtest.efi
		use iso64 && emake iso
	popd
}

install_memtest_images() {
	use bios32 && newins build32/memtest.bin memtest32.bios
	use bios64 && newins build64/memtest.bin memtest64.bios
	use efi32 && newins build32/memtest.efi memtest.efi32
	use efi64 && newins build64/memtest.efi memtest.efi64
}

src_install() {
	default
	if use boot; then
		exeinto /etc/grub.d/
		newexe "${FILESDIR}"/39_memtest86+-r2 39_memtest86+
		insinto /boot/memtest86plus
		install_memtest_images
	fi

	insinto /usr/share/${PN}
	install_memtest_images
	use iso32 && newins build32/memtest.iso memtest32.iso
	use iso64 && newins build64/memtest.iso memtest64.iso
}
