# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib

DESCRIPTION="A panel plug-in with monitoring support for GPRS/UMTS(3G)/HSDPA(3.5G) modems"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-cellmodem-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/pciutils
	virtual/libusb:0
	>=xfce-base/libxfcegui4-4.8
	>=xfce-base/xfce4-panel-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/xfce4-dev-tools
	virtual/pkgconfig"

src_prepare() {
	eapply -p0 "${FILESDIR}"/${P}-asneeded.patch
	eapply -p0 "${FILESDIR}"/${P}-link_for_xfce_warn.patch
	eapply -p0 "${FILESDIR}"/${P}-build.patch
	echo panel-plugin/cellmodem.desktop.in.in > po/POTFILES.skip
	default
}

src_configure() {
	AT_M4DIR=${EPREFIX}/usr/share/xfce4/dev-tools/m4macros eautoreconf
	econf --libexecdir="${EPREFIX}"/usr/$(get_libdir)
}
