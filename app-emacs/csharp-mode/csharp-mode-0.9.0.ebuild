# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp

DESCRIPTION="A derived Emacs mode implementing most of the C# rules"
HOMEPAGE="https://github.com/josteink/csharp-mode"
SRC_URI="https://github.com/josteink/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-install ${PN} csharp-mode.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc README.org
}
