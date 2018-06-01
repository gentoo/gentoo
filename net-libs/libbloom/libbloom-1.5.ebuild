# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A simple and small bloom filter implementation in plain C."
HOMEPAGE="https://github.com/jvirkki/libbloom"
SRC_URI="https://github.com/jvirkki/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	doheader bloom.h
	dolib.so build/${PN}.so*
}
