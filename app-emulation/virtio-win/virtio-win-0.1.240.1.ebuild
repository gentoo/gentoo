# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

MY_PV=$(ver_cut 1-3)
MY_DW=$(ver_rs 3 -)

DESCRIPTION="VirtIO drivers for Windows virtual machines running on KVM"
HOMEPAGE="https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html"
SRC_URI="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/${PN}-${MY_DW}/${PN}-${MY_PV}.iso"

LICENSE="BSD Apache-2.0 GPL-2 GPL-2+ GPL-3+ LGPL-2+ Ms-RL"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}"
INSTALL_PATH=/usr/share/drivers/windows

src_install() {
	insinto "${INSTALL_PATH}"
	doins "${DISTDIR}/${PN}-${MY_PV}.iso"
	dosym "${PN}-${MY_PV}.iso" "${INSTALL_PATH}/${PN}.iso"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
