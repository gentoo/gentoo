# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit font

MY_P="STIXv${PV}"
DESCRIPTION="Comprehensive OpenType font set of mathematical symbols and alphabets"
HOMEPAGE="http://www.stixfonts.org/"
SRC_URI="mirror://sourceforge/${PN/-/}/${MY_P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${MY_P}"
FONT_SUFFIX="otf"
FONT_S="${S}/Fonts/OTF"
FONT_CONF=( "${FILESDIR}"/61-stix.conf )

DOCS=( docs/STIX_2.0.0_release_notes.txt )

RESTRICT="binchecks strip test"
