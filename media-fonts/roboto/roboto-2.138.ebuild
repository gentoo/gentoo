# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Standard font for Android 4.0 (Ice Cream Sandwich) and later"
HOMEPAGE="https://github.com/googlefonts/roboto"
SRC_URI="https://github.com/googlefonts/${PN}/releases/download/v${PV}/roboto-unhinted.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="app-arch/unzip"

FONT_CONF=( "${FILESDIR}"/90-roboto-regular.conf )
FONT_SUFFIX="ttf"
