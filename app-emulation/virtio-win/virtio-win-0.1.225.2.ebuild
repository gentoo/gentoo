# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_cut 1-3)
MY_DW=$(ver_rs 3 -)

DESCRIPTION="VirtIO drivers for Windows virtual machines running on KVM"
HOMEPAGE="https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html"
SRC_URI="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/${PN}-${MY_DW}/${PN}-${MY_PV}.iso"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}"

src_install() {
	insinto /usr/share/drivers/windows
	doins "${DISTDIR}/${PN}-${MY_PV}.iso"
	dosym "${PN}-${MY_PV}.iso" "/usr/share/drivers/windows/${PN}.iso"
}
