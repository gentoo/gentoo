# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A commandline-based, portable human IP stack for UNIX/Linux"
HOMEPAGE="https://github.com/libnet/nemesis"
SRC_URI="https://github.com/libnet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 sparc x86"

RDEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
"
DOCS="ChangeLog.md docs/CONTRIBUTING.md docs/CREDITS README.md"
PATCHES=(
	"${FILESDIR}"/${PN}-1.7-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}
