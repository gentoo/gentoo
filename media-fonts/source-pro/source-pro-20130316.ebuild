# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit font

CODE_P=SourceCodePro_FontsOnly-1.017
SANS_P=SourceSansPro_FontsOnly-1.038

DESCRIPTION="Adobe Source Pro, an open source multi-lingual font family"
HOMEPAGE="http://blogs.adobe.com/typblography/2012/08/source-sans-pro.html
	http://blogs.adobe.com/typblography/2012/09/source-code-pro.html"
SRC_URI="mirror://sourceforge/sourcecodepro.adobe/${CODE_P}.zip
	mirror://sourceforge/sourcesans.adobe/${SANS_P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x64-macos"
IUSE=""

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

RDEPEND="media-libs/fontconfig"
DEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_SUFFIX="otf ttf"
FONT_S=${S}
FONT_CONF=( "${FILESDIR}"/63-${PN}.conf )

src_prepare() {
	# Put otf and ttf files in one directory so that font_src_install can
	# actually find them. We make this non-fatal because releases appear to be
	# alternating between having OTF/TTF subdirs and not, so it's easier just to
	# glob for everything.
	mv -vf ${CODE_P}/{OTF,TTF,""}/* .
	mv -vf ${SANS_P}/{OTF,TTF,""}/* .
}

src_install() {
	font_src_install
	dohtml *.html
}
