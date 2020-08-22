# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

GIT_COMMIT="b0d6223"
DESCRIPTION="Command line program for manipulating iTunes-style metadata in MPEG4 files"
HOMEPAGE="https://github.com/wez/atomicparsley"
SRC_URI="https://github.com/wez/atomicparsley/archive/${PV}.${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}.${GIT_COMMIT}"

src_install() {
	dobin "${BUILD_DIR}/AtomicParsley"
	dodoc README.md
}
