# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="OpenType and TrueType Unicode fonts from the Free UCS Outline Fonts Project"
HOMEPAGE="https://savannah.nongnu.org/projects/freefont/"
SRC_URI="mirror://gnu/freefont/${PN}-ttf-${PV}.zip
	mirror://gnu/freefont/${PN}-otf-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE=""

RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"

DOCS=( AUTHORS ChangeLog CREDITS TROUBLESHOOTING USAGE )

FONT_SUFFIX="otf ttf"
