# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for manipulating strings using various encodings"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

CMAKE_SKIP_TESTS=(
	# bug 938317
	rfc2047test
	kemailaddresstest
)
