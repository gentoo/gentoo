# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit rpm xdg-utils

MY_PN="mullvad-bin"  
DESCRIPTION="Official Mullvad VPN CLI for Linux"
HOMEPAGE="https://mullvad.net"
SRC_URI="https://github.com/mullvad/mullvadvpn-app/releases/download/${PV}/MullvadVPN-${PV}_x86_64.rpm"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}"
RESTRICT="strip"

src_unpack() {
    rpm_src_unpack "${A}"
}

src_install() {
    doinitd "${FILESDIR}/mullvadd"
    doinitd "${FILESDIR}/mullvadd-early-boot-blocking"
    cp -r "${S}"/* "${D}" || die "Install failed!"
}

pkg_postinst() {
    INIT_SYS="$(ps -p 1 -o comm=)"

    case $INIT_SYS in
        init)
            rc-service mullvadd start
            rc-update add mullvadd default
            echo "added mullvadd to runlevel default"
            ;;

        systemd)
            systemctl start mullvad-daemon
            systemctl enable mullvad-daemon
            echo "added mullvad-daemon to runlevel default"
            ;;
        
        *)
            "Couldn't find a supported init system"
            ;;
    esac

    xdg_icon_cache_update
}

pkg_postrm() {
    xdg_icon_cache_update
}
