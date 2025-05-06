# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="Turns your Realtek RTL2832 based DVB dongle into a SDR receiver"
HOMEPAGE="https://sdr.osmocom.org/trac/wiki/rtl-sdr"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.osmocom.org/${PN}"
else
	SRC_URI="https://github.com/osmocom/rtl-sdr/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-2+ GPL-3+"
# In 2.0.0 and 2.0.1, the SONAME was accidentally "2". In 2.0.2, it
# was restored back to "0" (see 7ebcb041f2ce887ef4d1a64607558889a86ff169 upstream).
# We can't really know what users built against what and when without
# us having had a subslot at the time, so we use 0.1 in it to be safe to avoid
# broken binaries by forcing rebuilds.
SLOT="0/0.1"
IUSE="+zerocopy"

DEPEND="virtual/libusb:1"
RDEPEND="
	${DEPEND}
	!net-wireless/rtl-sdr-blog
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.2-disable-static.patch"
	"${FILESDIR}/${PN}-2.0.2-pkgconfig-libdir.patch"
	"${FILESDIR}/${PN}-2.0.2-udev-rules-path.patch"

)

src_configure() {
	local mycmakeargs=(
		-DDETACH_KERNEL_DRIVER="ON"
		-DENABLE_ZEROCOPY="$(usex zerocopy)"
		-DINSTALL_UDEV_RULES="ON"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/rtl_tcp.initd-r1 rtl_tcp
	newconfd "${FILESDIR}"/rtl_tcp.confd-r1 rtl_tcp
}

pkg_postinst() {
	udev_reload
	elog "Only users in the usb group can capture."
	elog "Just run 'gpasswd -a <USER> usb', then have <USER> re-login."
}

pkg_postrm() {
	udev_reload
}
