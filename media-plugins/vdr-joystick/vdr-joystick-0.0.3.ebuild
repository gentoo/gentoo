# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: allows using a joystick as a remote control for VDR"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/joystick
	doins   "${FILESDIR}"/mapping.conf
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	elog "To use the plugin your joystick has to be connected to your"
	elog "game port and its kernel module has to be loaded."
	elog "Check configuration file:"
	elog "/etc/vdr/plugins/joystick/mapping.conf\n"
}
