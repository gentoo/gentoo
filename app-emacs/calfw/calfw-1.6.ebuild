# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A calendar framework for Emacs"
HOMEPAGE="https://github.com/kiwanami/emacs-calfw"
SRC_URI="https://github.com/kiwanami/emacs-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="howm"

RDEPEND="howm? ( app-emacs/howm )"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/emacs-${PN}-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="readme.md"

src_prepare() {
	elisp_src_prepare
	use howm || rm calfw-howm.el || die
}
