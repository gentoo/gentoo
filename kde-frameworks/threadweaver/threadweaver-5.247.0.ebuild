# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm frameworks.kde.org

DESCRIPTION="Framework for managing threads using job and queue-based interfaces"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	cmake_comment_add_subdirectory benchmarks
	ecm_src_prepare
}
