# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

DESCRIPTION="Mathematica's Fonts for MathML"
HOMEPAGE="http://support.wolfram.com/technotes/latestfonts.en.html"
SRC_URI="http://support.wolfram.com/technotes/MathematicaV7FontsLinux.tar.gz"

LICENSE="WRI-EULA"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

RESTRICT="mirror strip binchecks"
S=${WORKDIR}

src_install() {
	FONT_S="${S}"/Fonts/TTF FONT_SUFFIX="ttf" font_src_install
	FONT_S="${S}"/Fonts/Type1 FONT_SUFFIX="pfa" font_src_install
}

pkg_postinst() {
	einfo
	ewarn "Previously we suggested to set fonts in Mozilla or Firefox browsers."
	ewarn "If you did that, please, revert back since now everything should work"
	ewarn "out of box and no manual configuration required."
	einfo
	elog "To reset open web browser, enter the URL 'about:config', 'Filter' for"
	elog "'mathfont', and 'Reset' to the default value through the context menu on"
	elog "the preference."
	elog
	elog "Although if you still wish to use this fonts for MathML in web brower, then"
	elog "set font.mathfont-family to:"
	elog "Mathematica1, Mathematica2, Mathematica3, Mathematica4, Mathematica5, Mathematica6, Mathematica7"
	elog
	elog "Test your fonts at http://www.mozilla.org/projects/mathml/start.xhtml"
	einfo
}
