# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

MY_P="tg$(ver_cut 1)_$(ver_cut 2)otf"
DESCRIPTION="Extensive remake of freely available URW fonts"
HOMEPAGE="http://www.gust.org.pl/projects/e-foundry/tex-gyre"
SRC_URI="http://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/${MY_P}.zip"

LICENSE="LPPL-1.3c" # GUST Font License, equivalent to LPPL-1.3c
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~riscv x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"
FONT_SUFFIX="otf"
