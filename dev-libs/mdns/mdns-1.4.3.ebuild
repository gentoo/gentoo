# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Public domain mDNS/DNS-SD library in C"
HOMEPAGE="https://github.com/mjansson/mdns/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mjansson/mdns.git"
else
	SRC_URI="https://github.com/mjansson/mdns/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~loong ~x86"
fi

LICENSE="Unlicense"
SLOT="0"
