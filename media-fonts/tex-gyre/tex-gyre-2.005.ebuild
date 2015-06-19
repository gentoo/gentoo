# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/tex-gyre/tex-gyre-2.005.ebuild,v 1.1 2015/05/09 04:08:37 yngwin Exp $

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
