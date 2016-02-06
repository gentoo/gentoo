# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="An encoding detector library ported from Mozilla"
HOMEPAGE="https://github.com/BYVoid/uchardet"
SRC_URI="https://github.com/BYVoid/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="static-libs test"

PATCHES=(
	"${FILESDIR}/${P}-fix-ASCII-detection.patch"
	"${FILESDIR}/${P}-use-proper-package-name.patch"
	"${FILESDIR}/${P}-fix-return-code-on-error.patch"
)

src_prepare() {
	use test || cmake_comment_add_subdirectory test
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build static-libs STATIC)
	)
	cmake-utils_src_configure
}
