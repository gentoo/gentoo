# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"

inherit cmake flag-o-matic linux-info

DESCRIPTION="An unofficial userspace driver for HID++ Logitech devices"
HOMEPAGE="https://github.com/PixlOne/logiops"
SRC_URI="https://github.com/PixlOne/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

pkg_pretend() {
	local CHECK_CONFIG="~HID_LOGITECH ~HID_LOGITECH_HIDPP"

	check_extra_config
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/924426
	# https://github.com/PixlOne/logiops/issues/445
	filter-lto

	local mycmakeargs=(
		-DBUILD_SHARED="ON"
		-DBUILD_STATIC="OFF"
		-DLOGIOPS_VERSION="${PV}"
	)

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
