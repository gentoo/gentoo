# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} =~ [9]{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/chutz/mullvad-netns.git"
else
	SRC_URI="https://github.com/chutz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Script to run a command within a Mullvad network namespace"
HOMEPAGE="https://github.com/chutz/mullvad-netns"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	app-misc/jq
	app-shells/bash
	net-misc/curl[ipv6,ssl]
	net-vpn/wireguard-tools
	sys-apps/baselayout
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/iproute2[ipv6]
	sys-apps/util-linux
"
BDEPEND="
	sys-apps/coreutils
	sys-devel/make
"
