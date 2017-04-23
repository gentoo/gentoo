# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils versionator python-single-r1 readme.gentoo

MY_PV="$(get_version_component_range 1-2)"
MY_PL="$(get_version_component_range 3)"
MY_PL="s0${MY_PL}"
MY_PV="${MY_PV}.${MY_PL}"

DESCRIPTION="WiFi Radar is a Python/PyGTK2 utility for managing WiFi profiles"
HOMEPAGE="http://wifi-radar.tuxfamily.org/"
SRC_URI="${HOMEPAGE}pub/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-admin/sudo
	>=dev-python/pygtk-2.16.0-r1[${PYTHON_USEDEP}]
	>=net-wireless/wireless-tools-29
	|| ( net-misc/dhcpcd net-misc/dhcp net-misc/pump )
"

S="${WORKDIR}/${PN}-${MY_PV}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Remember to edit configuration file /etc/${PN}.conf to suit your needs.
To use ${PN} with a normal user (with sudo) add:
%users   ALL = /usr/sbin/${PN}
in your /etc/sudoers. Also, find the line saying:
Defaults      env_reset
and modify it as follows:
Defaults      env_keep=DISPLAY

Then launch ${PN}.sh
"

src_prepare() {
	sed -i "s:/etc/wpa_supplicant.conf:/etc/wpa_supplicant/wpa_supplicant.conf:" ${PN} || die
	sed -i -e "s:/sbin/ifconfig:/bin/ifconfig:" ${PN} || die
	python_fix_shebang .
}

src_install() {
	dosbin ${PN}
	dobin ${PN}.sh
	doicon -s scalable pixmaps/${PN}.svg
	doicon -s 32 pixmaps/wifi_radar_32x32.png
	doicon pixmaps/${PN}.png
	make_desktop_entry ${PN}.sh "WiFi Radar" ${PN} Network

	doman man/man1/${PN}.1 man/man5/${PN}.conf.5

	cd docs
	dodoc BUGS CREDITS DEVELOPER_GUIDELINES HISTORY README README.WPA-Mini-HOWTO.txt TODO
	keepdir /etc/${PN}

	readme.gentoo_create_doc
}
