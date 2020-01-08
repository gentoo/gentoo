# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A collection of profiles for the AppArmor application security system"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="minimal vanilla"

RESTRICT="test"

S=${WORKDIR}/${P}/profiles

pkg_setup() {
	if use vanilla; then
		EGIT_REPO_URI="https://gitlab.com/apparmor/apparmor.git"
		EGIT_BRANCH="master"
	else
		EGIT_REPO_URI="https://github.com/kensington/apparmor.git"
		EGIT_BRANCH="gentoo"
	fi
}

src_install() {
	if use minimal ; then
		insinto /etc/apparmor.d
		doins -r apparmor.d/{abstractions,tunables}
	else
		default
	fi
}
