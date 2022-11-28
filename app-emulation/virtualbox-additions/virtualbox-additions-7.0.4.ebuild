# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=VBoxGuestAdditions
MY_P=${MY_PN}_${PV}

DESCRIPTION="CD image containing guest additions for VirtualBox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/${PV}/${MY_P}.iso"

# Reminder 7.0.2:
# This package contains only the ISO, so the license is taken from COPYING
# But if we check the source files, some still use MIT or GPL-2+
# File a bug if the situation does not improve after a few more releases
LICENSE="GPL-3 CDDL"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_unpack() {
	return 0
}

src_install() {
	insinto /usr/share/${PN/-additions}
	newins "${DISTDIR}"/${MY_P}.iso ${MY_PN}.iso
}
