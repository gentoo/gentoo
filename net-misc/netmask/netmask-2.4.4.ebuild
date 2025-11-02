# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An IP address formatting tool"
HOMEPAGE="https://github.com/tlby/netmask"
SRC_URI="https://github.com/tlby/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default
	eautoreconf
}
