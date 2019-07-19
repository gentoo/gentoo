# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit font

DESCRIPTION="OpenType and TrueType Unicode fonts from the Free UCS Outline Fonts Project"
HOMEPAGE="https://savannah.nongnu.org/projects/freefont/"
SRC_URI="mirror://gnu/freefont/${PN}-ttf-${PV}.zip
	mirror://gnu/freefont/${PN}-otf-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="app-arch/unzip"

FONT_SUFFIX="otf ttf"
DOCS="AUTHORS ChangeLog CREDITS TROUBLESHOOTING USAGE"

RESTRICT="strip binchecks"
