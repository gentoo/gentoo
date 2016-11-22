# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="An encoding detector library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/uchardet/"
EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}/${PN}"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS=""
IUSE="static-libs test"

src_prepare() {
	cmake-utils_src_prepare
	use test || cmake_comment_add_subdirectory test
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC=$(usex static-libs)
	)
	cmake-utils_src_configure
}
