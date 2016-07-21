# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp eutils

DESCRIPTION="A calendar framework for Emacs"
HOMEPAGE="https://github.com/kiwanami/emacs-calfw"
SRC_URI="https://github.com/kiwanami/emacs-calfw/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="howm"

DEPEND="howm? ( app-emacs/howm )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	unpack ${A}
	mv kiwanami-emacs-calfw-* ${P} || die
}

src_prepare() {
	use howm || rm -f calfw-howm.el
}
