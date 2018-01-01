# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
fi

DESCRIPTION="highly flexible status line for the i3 window manager"
HOMEPAGE="https://github.com/vivien/i3blocks"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/vivien/${PN}"
	KEYWORDS="amd64 x86"
else
	SRC_URI="https://github.com/vivien/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

SLOT="0"
LICENSE="GPL-3"

RDEPEND="app-admin/sysstat
	media-sound/playerctl
	sys-apps/lm_sensors
	sys-power/acpi
	x11-wm/i3"

DEPEND="app-text/ronn"

PATCHES=( "${FILESDIR}/${PN}-default-sysconfdir.patch" ) #610090

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
