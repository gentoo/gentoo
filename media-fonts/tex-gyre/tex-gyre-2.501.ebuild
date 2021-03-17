# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

MY_P="tg$(ver_cut 1)_$(ver_cut 2)otf"
DESCRIPTION="Extensive remake of freely available URW fonts"
HOMEPAGE="http://www.gust.org.pl/projects/e-foundry/tex-gyre"
SRC_URI="http://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/${MY_P}.zip"

LICENSE="|| ( GFL LPPL-1.3c )" # legally equivalent
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"
FONT_SUFFIX="otf"
