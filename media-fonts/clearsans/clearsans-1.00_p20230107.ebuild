# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="1993725b24a36af21e7ebaa8977103983b608572"
MY_PN="clear-sans"

inherit font

DESCRIPTION="OpenType font optimized for readability on small screens"
HOMEPAGE="https://github.com/intel/clear-sans"
SRC_URI="https://github.com/intel/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~loong ~ppc64 ~riscv x86"

FONT_S="${S}/TTF"
FONT_SUFFIX="ttf"
