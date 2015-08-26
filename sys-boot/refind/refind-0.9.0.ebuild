# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The rEFInd UEFI Boot Manager by Rod Smith"
HOMEPAGE="http://www.rodsbooks.com/refind/index.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="btrfs +ext2 +ext4 hfs +iso9660 ntfs reiserfs"

DOCS="NEWS.txt README.txt refind.conf-sample docs/refind docs/Styles"

DEPEND=">=sys-boot/gnu-efi-3.0u"
RDEPEND=""

src_compile() {
	emake gnuefi

	pushd "${S}/filesystems" > /dev/null
	for fs in ${IUSE}; do
		fs=${fs#+}
		if use "${fs}"; then
			einfo "Building ${fs} filesystem driver"
			rm -f fsw_efi.o

			# ARCH detection in the Makefile not working
			use x86 && buildarch=ia32
			use amd64 && buildarch=x86_64
			emake DRIVERNAME=${fs} ARCH=${buildarch} -f Make.gnuefi
		fi
	done
	popd > /dev/null
}

src_install() {
	exeinto "/usr/share/${P}"
	doexe install.sh

	dodoc -r ${DOCS}

	insinto "/usr/share/${P}/refind"
	use x86 && doins refind/refind_ia32.efi
	use amd64 && doins refind/refind_x64.efi

	use x86 && filearch=ia32
	use amd64 && filearch=x64
	insinto "/usr/share/${P}/refind/drivers_${filearch}"
	for fs in ${IUSE}; do
		fs=${fs#+}
		if use "${fs}"; then
			doins "drivers_${filearch}/${fs}_${filearch}.efi"
		fi
	done

	insinto "/usr/share/${P}/refind"
	doins -r images icons fonts banners

	insinto "/usr/share/${P}/keys"
	doins keys/*
}

pkg_postinst() {
	einfo ""
	einfo "EFI executables have been built and installed into /usr/share/${P}"
	einfo "You will need to use the provided install script 'install.sh' or"
	einfo "manually install the binaries into your EFI System Partition"
	einfo ""
	einfo "For key generation and binary signing for use with SecureBoot, the"
	einfo "package app-crypt/sbsigntool can be installed"
	einfo ""
	einfo "A sample configration can be found at"
	einfo "/usr/share/doc/${P}/refind.conf-sample.bz2"
	einfo ""
}
