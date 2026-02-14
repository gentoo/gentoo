# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="library for communicating with HackRF SDR platform"
HOMEPAGE="http://greatscottgadgets.com/hackrf/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/greatscottgadgets/hackrf.git"
	inherit git-r3
	EGIT_CHECKOUT_DIR="${WORKDIR}/hackrf"
	S="${WORKDIR}/hackrf/host/libhackrf"
else
	S="${WORKDIR}/hackrf-${PV}/host/libhackrf"
	SRC_URI="https://github.com/greatscottgadgets/hackrf/releases/download/v${PV}/hackrf-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="+udev"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_UDEV_RULES="$(usex udev)"
		-DENABLE_STATIC_LIB=OFF
	)
	if use udev; then
		mycmakeargs+=(
			-DUDEV_RULES_GROUP=usb
			-DUDEV_RULES_PATH="$(get_udevdir)/rules.d"
		)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_build hackrf
}

pkg_postinst() {
	if use udev; then
		einfo "Users in the usb group can use hackrf."
		udev_reload
	fi
}

pkg_postrm() {
	udev_reload
}
