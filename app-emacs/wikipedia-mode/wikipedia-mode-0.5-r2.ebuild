# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Mode for editing Wikipedia articles off-line"
HOMEPAGE="https://www.emacswiki.org/emacs/WikipediaMode"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="outline-magic"

RDEPEND="outline-magic? ( app-emacs/outline-magic )"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	use outline-magic && eapply "${FILESDIR}"/${P}-require-outline-magic.patch
	eapply_user
}
