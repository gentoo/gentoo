# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info

MY_PV="${PV/_rc/-RC}"

DESCRIPTION="ncurses interface for QEMU"
HOMEPAGE="https://github.com/nemuTUI/nemu"
SRC_URI="https://github.com/nemuTUI/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus network-map +ovf remote-api"

RDEPEND="
	>=app-emulation/qemu-6.0.0-r3[vnc,virtfs,spice]
	dev-db/sqlite:3=
	dev-libs/json-c
	sys-libs/ncurses:=[unicode(+)]
	virtual/libusb:1
	virtual/libudev:=
	dbus? ( sys-apps/dbus )
	network-map? ( media-gfx/graphviz[svg] )
	ovf? (
		dev-libs/libxml2:2
		app-arch/libarchive:=
	)
	remote-api? ( dev-libs/openssl )
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"
S="${WORKDIR}/${PN}-${MY_PV}/"

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

src_configure() {
	# -DNM_WITH_QEMU: Do not embbed qemu.
	local mycmakeargs=(
		-DNM_WITH_DBUS=$(usex dbus)
		-DNM_WITH_NETWORK_MAP=$(usex network-map)
		-DNM_WITH_REMOTE=$(usex remote-api)
		-DNM_WITH_OVF_SUPPORT=$(usex ovf)
		-DNM_WITH_QEMU=off
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docompress -x /usr/share/man/man1/nemu.1.gz
}

pkg_postinst() {
	elog "For non-root usage execute script:"
	elog "/usr/share/nemu/scripts/setup_nemu_nonroot.sh linux <username>"
	elog "and add udev rule:"
	elog "cp /usr/share/nemu/scripts/42-net-macvtap-perm.rules /etc/udev/rules.d"
	elog "Afterwards reboot or reload udev with"
	elog "udevadm control --reload-rules && udevadm trigger"
}
