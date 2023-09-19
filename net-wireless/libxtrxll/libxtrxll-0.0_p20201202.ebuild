# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Low-level XTRX hardware abstraction library"
HOMEPAGE="https://github.com/xtrx-sdr/libxtrxll"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"

if [[ ${PV} =~ "9999" ]]; then
	EGIT_REPO_URI="https://github.com/xtrx-sdr/libxtrxll.git"
	inherit git-r3
else
	COMMIT="1b6eddfbedc700efb6f7e3c3594e43ac6ff29ea4"
	SRC_URI="https://github.com/xtrx-sdr/libxtrxll/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

IUSE="usb3380"

RDEPEND="usb3380? ( net-wireless/libusb3380 )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_PCIE=ON
		-DENABLE_USB3380="$(usex usb3380 ON OFF)"
	)
	cmake_src_configure
}
