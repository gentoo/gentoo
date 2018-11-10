# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Streaming RNA-Seq Analysis"
HOMEPAGE="http://bio.math.berkeley.edu/eXpress/"
SRC_URI="http://bio.math.berkeley.edu/eXpress/downloads/${P}/${P}-src.tgz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-libs/boost-1.52.0:=
	dev-libs/protobuf
	dev-util/google-perftools
	sci-biology/bamtools
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}"/${P}-buildsystem.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_configure() {
	local mycmakeargs=(
		-DBAMTOOLS_INCLUDE="${EPREFIX}/usr/include/bamtools"
	)
	cmake-utils_src_configure
}
