# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27.1"
inherit elisp unpacker

DESCRIPTION="Completion kind icons"
HOMEPAGE="https://github.com/jdtsmith/kind-icon"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.lz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-emacs/svg-lib"
DEPEND="${RDEPEND}"
BDEPEND="$(unpacker_src_uri_depends)"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-make-autoload-file
	elisp_src_install
}
