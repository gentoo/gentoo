# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Chinese tables for IBus-Table"
HOMEPAGE="https://github.com/mike-fabian/ibus-table-chinese"
SRC_URI="https://github.com/mike-fabian/ibus-table-chinese/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-i18n/ibus-table"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/ibus-table-chinese-1.8.14_install-paths.patch"
)
