# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Grub2 built as a PV grub per the Xen PV Boot Protocol"
HOMEPAGE="https://blog.xenproject.org/2015/01/07/using-grub-2-as-a-bootloader-for-xen-pv-guests/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="sys-boot/grub:2=[grub_platforms_xen]
	app-emulation/xen-tools:="
RDEPEND="${DEPEND}"

S="${WORKDIR}"

STRIP_MASK="usr/libexec/xen/bin/grub-x86_64-xen.bin"
QA_EXECSTACK="usr/libexec/xen/bin/grub-x86_64-xen.bin"
QA_WX_LOAD="usr/libexec/xen/bin/grub-x86_64-xen.bin"
QA_PRESTRIPPED="usr/libexec/xen/bin/grub-x86_64-xen.bin"
RESTRICT="test"

src_configure() {
	:
}

src_compile() {
	cat > "${S}/grub-bootstrap.cfg" <<- EOF
		normal (memdisk)/grub.cfg
	EOF

	cat > "${S}/grub.cfg" <<- EOF
		if search -s -f /boot/xen/pvboot-x86_64.elf ; then
			echo "Chainloading (${root})/boot/xen/pvboot-x86_64.elf"
			multiboot "/boot/xen/pvboot-x86_64.elf"
			boot
		fi

		if search -s -f /xen/pvboot-x86_64.elf ; then
			echo "Chainloading (${root})/xen/pvboot-x86_64.elf"
			multiboot "/xen/pvboot-x86_64.elf"
			boot
		fi

		if search -s -f /boot/grub/grub.cfg ; then
			echo "Reading (${root})/boot/grub/grub.cfg"
			configfile /boot/grub/grub.cfg
		fi

		if search -s -f /grub/grub.cfg ; then
			echo "Reading (${root})/grub/grub.cfg"
			configfile /grub/grub.cfg
		fi
	EOF

	tar cf memdisk.tar grub.cfg || die "failed to tar"

	grub2-mkimage -O x86_64-xen \
		-c grub-bootstrap.cfg \
		-m memdisk.tar \
		-o grub-x86_64-xen.bin \
		/usr/lib/grub/x86_64-xen/*.mod \
		|| die "failed to grub-mkimage"
}

src_install() {
	exeinto /usr/libexec/xen/bin
	doexe grub-x86_64-xen.bin
}
