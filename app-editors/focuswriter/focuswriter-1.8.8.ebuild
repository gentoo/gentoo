# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fullscreen and distraction-free word processor"
HOMEPAGE="https://gottcode.org/focuswriter/
	https://github.com/gottcode/focuswriter"
SRC_URI="https://gottcode.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-3+ LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"
RDEPEND="
	app-text/hunspell:=
	dev-qt/qtbase:6[concurrent,gui,widgets]
	dev-qt/qtmultimedia:6
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
