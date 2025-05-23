# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="A stub for generating a GRUB/GRUB2 configuration"
HOMEPAGE="https://manpages.debian.org/testing/grub2-common/update-grub.8.en.html"

# SRC_URI will point to the amd64 Debian package
# Bear in mind this ebuild only installs the shell script, and should therefore run on any platform with Bash installed

SRC_URI="http://ftp.debian.org/debian/pool/main/g/grub2/grub2-common_2.06-8_amd64.deb"

LICENSE="GPL-3"
SLOT="0"

# Use the same architecture keywords as sys-boot/grub

KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
S=${WORKDIR}

DEPEND="
	sys-boot/grub
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/binutils
"

src_unpack() {
	unpack_deb grub2-common_2.06-8_amd64.deb
}
src_install() {
	exeinto "/usr/sbin"
	doexe "${S}/usr/sbin/update-grub"
	dosym "/usr/sbin/update-grub" "/usr/sbin/update-grub2"
}
pkg_postinst() {
	elog "update-grub has been installed to /usr/sbin."
	elog "\nSome systems may not have /usr/sbin in their PATH; if this is the case for your system, you may want to do so."
	elog "\nAfter updating PATH, remember to run . /etc/profile in your shell."
}
