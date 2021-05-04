# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

COMMIT=045774dee7cab1a618a3e0d9b39bff78a12b6efa

DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="https://dev.openttdcoop.org/projects/grfcodec"
SRC_URI="https://github.com/OpenTTD/grfcodec/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng:0"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	dev-libs/boost
"

S="${WORKDIR}/grfcodec-${COMMIT}"

src_install() {
	dobin "${BUILD_DIR}"/{grfcodec,grfid,grfstrip,nforenum}
	doman docs/*.1
	dodoc changelog.txt docs/*.txt
}
