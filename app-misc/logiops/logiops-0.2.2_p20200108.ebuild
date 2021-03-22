# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="a0687c8f18e312824ac04043c410b637ce89e371"

inherit cmake linux-info

DESCRIPTION="An unofficial userspace driver for HID++ Logitech devices"
HOMEPAGE="https://github.com/PixlOne/logiops"
SRC_URI="https://github.com/PixlOne/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

DEPEND="
	dev-libs/libconfig:=[cxx]
	dev-libs/libevdev
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

src_install() {
	default

	cmake_src_install

	insinto /etc
	newins logid.example.cfg logid.cfg

	newinitd "${FILESDIR}"/logid.initd logid
}

pkg_postinst() {
	einfo "An example config file has been installed as /etc/logid.cfg."
	einfo "See https://github.com/PixlOne/logiops/wiki/Configuration for more information."
}
