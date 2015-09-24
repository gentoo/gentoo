# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Enables the user to edit different parts of a file in different major modes"
HOMEPAGE="http://mmm-mode.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+ Texinfo-manual"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	# fix bug 561306
	for file in configure elisp-comp; do
		sed -i -e "s/-batch/-batch --no-site-file/g" $file || die
	done
}

src_configure() {
	econf --with-emacs
}

src_compile() {
	emake -j1
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo *.info*
	dodoc AUTHORS ChangeLog FAQ NEWS README README.Mason TODO
}
