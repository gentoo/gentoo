# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit font

MY_P="ttf-sinhala-${P}"
DESCRIPTION="Sinhala font"
HOMEPAGE="http://sinhala.sourceforge.net"
SRC_URI="http://sinhala.sourceforge.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"

FONT_SUFFIX="ttf"

DOCS="README.fonts"
