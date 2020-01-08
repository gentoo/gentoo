# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="Extensive remake of freely available URW fonts"
HOMEPAGE="http://www.gust.org.pl/projects/e-foundry/tex-gyre"
SRC_URI="${HOMEPAGE}/whole/tg-${PV}otf.zip"

LICENSE="|| ( GFL LPPL-1.3c )" # legally equivalent
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 ~hppa x86"

S=${WORKDIR}
FONT_SUFFIX="otf"
