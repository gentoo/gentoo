# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils linux-info udev

DESCRIPTION="turns FL2000-based USB 3.0 to VGA adapters into low cost DACs"

HOMEPAGE="https://osmocom.org/projects/osmo-fl2k/wiki"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.osmocom.org/osmo-fl2k"
else
	KEYWORDS="~amd64"
	SRC_URI="mirror://gentoo/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="0"

IUSE="udev"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}
	media-sound/sox
	sys-apps/pv"

# continguous memory allocator can optionally be used for zero-copy transfer
# TODO: tell users to set CONFIG_CMA_SIZE_MBYTES or boot with cma=... parameter
CONFIG_CHECK="~CMA ~DMA_CMA"

src_configure() {
	# udev rules use wrong filename and would go to wrong directory anyway
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
		-DINSTALL_UDEV_RULES=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	if use udev; then
		udev_newrules ${PN}.rules 99-${PN}.rules
	fi
	cmake-utils_src_install
}
