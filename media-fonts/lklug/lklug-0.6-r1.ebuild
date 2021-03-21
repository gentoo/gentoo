# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="ttf-sinhala-${P}"
inherit font

DESCRIPTION="Unicode Sinhala font"
HOMEPAGE="http://sinhala.sourceforge.net/"
SRC_URI="http://sinhala.sourceforge.net/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ppc ppc64 x86"
IUSE=""

DOCS=( README.fonts )

FONT_SUFFIX="ttf"
