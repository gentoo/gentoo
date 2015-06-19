# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/express/express-1.5.1.ebuild,v 1.1 2014/10/13 07:56:29 jlec Exp $

EAPI=5

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
	sys-libs/zlib
	sci-biology/bamtools"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}"/${P}-buildsystem.patch
)

src_configure() {
	local mycmakeargs=(
		-DBAMTOOLS_INCLUDE="${EPREFIX}/usr/include/bamtools"
	)
	cmake-utils_src_configure
}
