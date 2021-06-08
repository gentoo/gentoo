# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Streaming RNA-Seq Analysis"
HOMEPAGE="https://pachterlab.github.io/eXpress/"
SRC_URI="https://pachterlab.github.io/eXpress/downloads/${P}/${P}-src.tgz"

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
	cmake_src_configure
}
