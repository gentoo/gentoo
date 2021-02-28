# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info udev vdr-plugin-2

VERSION="2086" # every bump, new version

DESCRIPTION="VDR Plugin: shows information about the current state of VDR on iMON LCD"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-imonlcd/wiki"
SRC_URI="https://projects.vdr-developer.org/attachments/download/${VERSION}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/freetype
	virtual/udev"
DEPEND="${RDEPEND}
	media-video/vdr"
QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"

DOCS=(
	HISTORY
	README
)
PATCHES=(
	"${FILESDIR}/${PN}-1.0.2-freetype_pkgconfig.patch"
)
CONFIG_CHECK="~IR_IMON"

pkg_setup() {
	linux-info_pkg_setup
	vdr-plugin-2_pkg_setup
}

src_install() {
	rm -f README.git
	vdr-plugin-2_src_install

	udev_dorules "${FILESDIR}"/99-imonlcd.rules
}

pkg_postinst() {
	udev_reload
}
