# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Framework for managing threads using job and queue-based interfaces"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm x86"
IUSE=""

src_prepare() {
	cmake_comment_add_subdirectory benchmarks
	kde5_src_prepare
}
