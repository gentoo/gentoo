# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils linux-info

DESCRIPTION="ncurses interface for QEMU"
HOMEPAGE="https://lib.void.so/nemu"
SRC_URI="http://lib.void.so/src/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+vnc-client +ovf savevm debug"

RDEPEND="
	virtual/udev:=
	dev-db/sqlite:3=
	virtual/libusb:1
	app-emulation/qemu[vnc,virtfs]
	sys-libs/ncurses:0=[unicode]
	ovf? (
		dev-libs/libxml2
		app-arch/libarchive
	)
	vnc-client? ( net-misc/tigervnc )"

DEPEND="
	${RDEPEND}
	sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		-DNM_WITH_VNC_CLIENT=$(usex vnc-client)
		-DNM_DEBUG=$(usex debug)
		-DNM_SAVEVM_SNAPSHOTS=$(usex savevm)
		-DNM_WITH_OVF_SUPPORT=$(usex ovf)
	)
	cmake-utils_src_configure
}

pkg_pretend() {
	if use kernel_linux; then
		if ! linux_config_exists; then
			eerror "Unable to check your kernel"
		else
			CONFIG_CHECK="~VETH ~MACVTAP"
			ERROR_VETH="You will need the Virtual ethernet pair device driver compiled"
			ERROR_VETH+=" into your kernel or loaded as a module to use the"
			ERROR_VETH+=" local network settings feature."
			ERROR_MACVTAP="You will also need support for MAC-VLAN based tap driver."

			check_extra_config
		fi
	fi
}

pkg_postinst() {
	elog "For non-root usage execute script:"
	elog "/usr/share/nemu/scripts/setup_nemu_nonroot.sh linux <username>"
	elog "and add udev rule:"
	elog "cp /usr/share/nemu/scripts/42-net-macvtap-perm.rules /lib/udev/rules.d"
	if use savevm; then
		elog ""
		elog "QEMU must be patched with qemu-qmp-savevm-VERSION.patch"
		elog "Get this patch from nEMU repository"
	fi
}
