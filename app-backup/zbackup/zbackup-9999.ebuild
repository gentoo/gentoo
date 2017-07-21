# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="A versatile deduplicating backup tool"
HOMEPAGE="http://zbackup.org/ https://github.com/zbackup/zbackup"
SRC_URI=""
EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"

LICENSE="GPL-2+-with-openssl-exception"
KEYWORDS=""
SLOT="0"
IUSE="libressl tartool"

DEPEND="app-arch/lzma
	dev-libs/lzo:2
	<dev-libs/protobuf-3:0=
	sys-libs/libunwind:7
	sys-libs/zlib
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
RDEPEND="${DEPEND}"

# Add tartool build
PATCHES=( "${FILESDIR}/${P}-tartool.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TARTOOL="$(usex tartool)"
	)

	cmake-utils_src_configure
}
