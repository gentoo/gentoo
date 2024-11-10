# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="https://github.com/OpenTTD/grfcodec"
SRC_URI="https://github.com/OpenTTD/grfcodec/releases/download/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="media-libs/libpng:="
DEPEND="${RDEPEND}
	dev-libs/boost"

PATCHES=(
	# Bug #894648
	"${FILESDIR}"/${PN}-6.0.6_p20230811-no-fortify-source.patch
)

src_install() {
	dobin "${BUILD_DIR}"/{grfcodec,grfid,grfstrip,nforenum}
	doman docs/*.1
	dodoc changelog.txt docs/*.txt
}
