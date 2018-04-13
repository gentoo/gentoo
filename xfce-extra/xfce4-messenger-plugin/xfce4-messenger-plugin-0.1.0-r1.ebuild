# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib

DESCRIPTION="A plugin that listens DBus messages and displays received messages"
HOMEPAGE="https://packages.qa.debian.org/x/xfce4-messenger-plugin.html"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV}-5.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	>=dev-libs/glib-2
	sys-apps/dbus
	x11-libs/gtk+:2
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/libxfcegui4-4.8
	>=xfce-base/xfce4-panel-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	eapply "${WORKDIR}"/debian/patches
	AT_M4DIR=${EPREFIX}/usr/share/xfce4/dev-tools/m4macros eautoreconf
	default
}

src_configure() {
	econf --libexecdir="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	default
	exeinto /usr/share/doc/${PF}/scripts
	doexe scripts/xfce-messenger-logtail
}
