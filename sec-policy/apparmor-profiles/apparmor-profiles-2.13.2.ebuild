# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="A collection of profiles for the AppArmor application security system"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"
SRC_URI="https://launchpad.net/apparmor/${MY_PV}/${PV}/+download/apparmor-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="minimal"

RESTRICT="test"

S=${WORKDIR}/apparmor-${PV}/profiles

src_install() {
	if use minimal ; then
		insinto /etc/apparmor.d
		doins -r apparmor.d/{abstractions,tunables}
	else
		default
	fi
}
