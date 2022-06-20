# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs udev vdr-plugin-2

DESCRIPTION="VDR Plugin: shows information about the current state of VDR on iMON LCD"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-imonlcd/wiki"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-imonlcd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-imonlcd-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/freetype
	virtual/udev"
DEPEND="${RDEPEND}
	media-video/vdr"
BDEPEND="virtual/pkgconfig"
QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"
DOCS=(
	HISTORY
	README
)
CONFIG_CHECK="~IR_IMON"

pkg_setup() {
	linux-info_pkg_setup
	vdr-plugin-2_pkg_setup
}

src_configure() {
	tc-export PKG_CONFIG
	default
}

src_install() {
	rm README.git || die
	vdr-plugin-2_src_install

	udev_dorules "${FILESDIR}"/99-imonlcd.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
