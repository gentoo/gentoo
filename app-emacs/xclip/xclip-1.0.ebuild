# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/xclip/xclip-1.0.ebuild,v 1.2 2012/07/15 18:06:56 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="Emacs Interface to XClip"
HOMEPAGE="http://elpa.gnu.org/packages/"
SRC_URI="mirror://gentoo/${P}.el.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND="x11-misc/xclip"

SITEFILE="50${PN}-gentoo.el"

pkg_postinst() {
	elisp-site-regen
	elog "To enable xclip-mode, add (xclip-mode 1) to your ~/.emacs file."
}
