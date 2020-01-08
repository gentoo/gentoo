# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font
FONTDIR="/usr/share/fonts/indic/${PN}"
FONT_SUFFIX="ttf"

DESCRIPTION="The Lohit Devanagari font"
HOMEPAGE="https://pagure.io/lohit"
SRC_URI="https://releases.pagure.org/lohit/${PN}-${FONT_SUFFIX}-${PV}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ppc ppc64 s390 sh sparc x86 ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="!<media-fonts/lohit-fonts-2.20150220"
RDEPEND="${DEPEND}"

RESTRICT="test binchecks"
S=${WORKDIR}/${PN}-${FONT_SUFFIX}-${PV}
FONT_S=${S}
FONT_CONF=( "66-${PN}.conf" )
