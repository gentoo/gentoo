# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Extension for nxml-mode with Gentoo-specific schemas"
HOMEPAGE="https://gitweb.gentoo.org/proj/nxml-gentoo-schemas.git/"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

SITEFILE="60${PN}-gentoo.el"

src_compile() { :; }

src_install() {
	insinto "${SITEETC}/${PN}"
	doins schemas.xml *.rnc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
