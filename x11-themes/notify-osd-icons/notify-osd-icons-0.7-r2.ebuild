# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Icons for on-screen-display notification agent"
HOMEPAGE="https://launchpad.net/notify-osd"
SRC_URI="mirror://ubuntu/pool/main/n/${PN}/${PN}_${PV}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-misc/notify-osd"

src_install() {
	default

	# Source: debian/notify-osd-icons.links
	local path=/usr/share/notify-osd/icons/gnome/scalable/status
	dosym notification-battery-000.svg ${path}/notification-battery-empty.svg
	dosym notification-battery-020.svg ${path}/notification-battery-low.svg

	dodoc AUTHORS debian/changelog
}
