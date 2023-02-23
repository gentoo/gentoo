# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="Usemode driver and associated tools for airspy"
HOMEPAGE="http://www.airspy.com"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/airspy/host.git"
else
	SRC_URI="https://github.com/airspy/host/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/airspyone_host-${PV}"
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="+udev"

RDEPEND="
	virtual/udev
	virtual/libusb:1"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.0.10-remove-static-libs.patch )

src_configure() {
	local mycmakeargs=(
		-DINSTALL_UDEV_RULES=$(usex udev)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use udev; then
		udev_newrules "${ED}"/etc/udev/rules.d/52-airspy.rules 52-airspy.rules
		rm -r "${ED}"/etc || die
	fi
}

pkg_postinst() {
	use udev && udev_reload
}

pkg_postrm() {
	use udev && udev_reload
}
