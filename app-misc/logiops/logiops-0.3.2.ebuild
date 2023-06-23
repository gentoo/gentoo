# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN_IPCGULL="ipcgull"
MY_PV_IPCGULL="0.1"

inherit cmake linux-info

DESCRIPTION="An unofficial userspace driver for HID++ Logitech devices"
HOMEPAGE="https://github.com/PixlOne/logiops"
SRC_URI="
	https://github.com/PixlOne/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/PixlOne/${MY_PN_IPCGULL}/archive/refs/tags/v${MY_PV_IPCGULL}.tar.gz -> ${MY_PN_IPCGULL}-${MY_PV_IPCGULL}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="systemd"

DEPEND="
	dev-libs/glib
	dev-libs/libconfig:=[cxx]
	dev-libs/libevdev
	sys-apps/dbus
	virtual/libudev
	systemd? ( sys-apps/systemd )
"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

DOCS=( "README.md" "TESTED.md" )

PATCHES=( "${FILESDIR}/${MY_PN_IPCGULL}-0.1-gcc13.patch" )

pkg_pretend() {
	local CHECK_CONFIG="~HID_LOGITECH ~HID_LOGITECH_HIDPP"

	check_extra_config
}

src_unpack() {
	default

	# Submodule, which needs to be present for compilation
	mv "${WORKDIR}/${MY_PN_IPCGULL}-${MY_PV_IPCGULL}" "${WORKDIR}/${MY_PN_IPCGULL}" || die
	mv "${WORKDIR}/${MY_PN_IPCGULL}" "${S}/src" || die
}

src_configure() {
	local mycmakeargs=( -DLOGIOPS_VERSION="${PV}" )

	cmake_src_configure
}

src_install() {
	default

	cmake_src_install

	# Install lib of submodule, as no install routine exist
	dolib.so "${BUILD_DIR}/src/ipcgull/libipcgull.so"

	insinto /etc
	newins logid.example.cfg logid.cfg

	newinitd "${FILESDIR}"/logid.initd logid
}

pkg_postinst() {
	einfo "An example config file has been installed as /etc/logid.cfg."
	einfo "See https://github.com/PixlOne/logiops/wiki/Configuration for more information."
}
