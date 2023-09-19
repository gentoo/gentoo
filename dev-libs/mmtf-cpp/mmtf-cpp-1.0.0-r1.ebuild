# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The pure C++ implementation of the MMTF API, decoder and encoder"
HOMEPAGE="https://github.com/rcsb/mmtf-cpp"
SRC_URI="https://github.com/rcsb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="dev-libs/msgpack"
RDEPEND="${DEPEND}"
BDEPEND=""
