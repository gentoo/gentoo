# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

DESCRIPTION="Metafont font used in Austrian schools for hand writing"
HOMEPAGE="http://www.ctan.org/tex-archive/fonts/oesch/"
# taken from http://www.ctan.org/tex-archive/fonts/oesch.zip
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86-fbsd"
IUSE="examples"

RDEPEND="!<dev-texlive/texlive-fontsextra-2007-r1"
DEPEND="${RDEPEND}
	app-arch/unzip"

TEXMF="/usr/share/texmf-site"

S=${WORKDIR}/${PN}

src_install() {
	export VARTEXFONTS="${T}/fonts"
	latex-package_src_install
	insinto "${TEXMF}/fonts/source/public"
	doins *.mf || die "failed to install metafont sources"
	dodoc README LIESMICH
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins *.tex || die "failed to install examples"
	fi
}
