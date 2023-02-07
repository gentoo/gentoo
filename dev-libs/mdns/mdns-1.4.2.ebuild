# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Public domain mDNS/DNS-SD library in C"
HOMEPAGE="https://github.com/mjansson/mdns"
SRC_URI="https://github.com/mjansson/mdns/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-timeval.patch"
)
