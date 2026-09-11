# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.9.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for managing threads using job and queue-based interfaces"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND=">=dev-qt/qtbase-${QTMIN}:6"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_comment_add_subdirectory benchmarks
	ecm_src_prepare
}
