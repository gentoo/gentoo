# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm xdg-utils

DESCRIPTION="Official Mullvad VPN CLI for Linux"
HOMEPAGE="https://mullvad.net"
SRC_URI="https://github.com/mullvad/mullvadvpn-app/releases/download/${PV}/MullvadVPN-${PV}_x86_64.rpm"
S="${WORKDIR}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
QA_PRESTRIPPED="/opt/Mullvad VPN/resources/libtalpid_openvpn_plugin.so 
    /opt/Mullvad VPN/resources/mullvad-problem-report 
    /opt/Mullvad VPN/resources/mullvad-setup 
    /opt/Mullvad VPN/resources/openvpn 
    /usr/bin/mullvad-daemon 
    /usr/bin/mullvad-exclude 
    /usr/bin/mullvad"
DEPEND="sys-apps/dbus 
    x11-libs/libXScrnSaver
    x11-libs/libnotify 
    net-libs/libnsl"
RDEPEND="${DEPEND}"

src_install() {
doinitd "${FILESDIR}/mullvadd"
doinitd "${FILESDIR}/mullvadd-early-boot-blocking"
cp -r "${S}"/* "${D}" || die "Install failed!"
}

pkg_postinst() {
xdg_icon_cache_update
}

pkg_postrm() {
xdg_icon_cache_update
}
