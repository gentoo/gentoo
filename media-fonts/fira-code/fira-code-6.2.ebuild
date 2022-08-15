# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

S=${WORKDIR}
FONT_S="${S}/ttf"
FONT_SUFFIX="ttf"
inherit font

DESCRIPTION="Monospaced font with programming ligatures"
HOMEPAGE="https://github.com/tonsky/FiraCode"
SRC_URI="https://github.com/tonsky/FiraCode/releases/download/${PV}/Fira_Code_v${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~riscv x86"

DOCS=( README.txt specimen.html fira_code.css )

BDEPEND="app-arch/unzip"
