# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LZFSE compression utilities"
HOMEPAGE="https://github.com/lzfse/lzfse"
SRC_URI="https://github.com/lzfse/lzfse/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"
