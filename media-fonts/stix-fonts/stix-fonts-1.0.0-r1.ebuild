# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

DESCRIPTION="Comprehensive OpenType font set of mathematical symbols and alphabets"
HOMEPAGE="http://www.stixfonts.org/"
SRC_URI="mirror://gentoo/STIXv${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ~ppc64 x86 ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/STIXv${PV}"
FONT_SUFFIX="otf"
FONT_S="${S}/Fonts"
FONT_CONF=( "${FILESDIR}"/61-stix.conf )

src_install() {
	# DOCS can't do files with spaces so handle it ourselves
	font_src_install
	dodoc "STIX Font Release Documentation 2010.pdf"
	use doc && dodoc "${S}"/Glyphs/*.pdf
}

RESTRICT="strip binchecks"
