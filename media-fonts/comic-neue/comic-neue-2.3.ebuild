# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Typographically savvy casual script typeface"
HOMEPAGE="http://comicneue.com"
SRC_URI="http://comicneue.com/${P}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
KEYWORDS="~alpha amd64 arm ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
SLOT="0"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="otf"
FONT_S=${S}/OTF
