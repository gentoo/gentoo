# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit font

DESCRIPTION="A monospace bitmap font, primarily aimed at programmers"
HOMEPAGE="http://www.donationcoder.com/Software/Jibz/Dina/index.html"
SRC_URI="https://dev.gentoo.org/~jstein/dist/dina-pcf-${PV}.tar.gz"

LICENSE="Dina"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/Dina-PCF
FONT_S=${WORKDIR}/Dina-PCF
FONT_SUFFIX="pcf"
