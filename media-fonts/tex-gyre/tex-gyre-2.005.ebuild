# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="Extensive remake of freely available URW fonts"
HOMEPAGE="http://www.gust.org.pl/projects/e-foundry/tex-gyre"
SRC_URI="${HOMEPAGE}/whole/tg-${PV}otf.zip"

LICENSE="|| ( GFL LPPL-1.3c )" # legally equivalent
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

S=${WORKDIR}
FONT_SUFFIX="otf"
