# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="A collection of profiles for the AppArmor application security system"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"

EGIT_REPO_URI="https://gitlab.com/apparmor/apparmor.git"
EGIT_BRANCH="master"

S=${WORKDIR}/${P}/profiles
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="minimal"

RESTRICT="test"

src_install() {
	if use minimal ; then
		insinto /etc/apparmor.d
		doins -r apparmor.d/{abi,abstractions,tunables}
	else
		default
	fi
}
