# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="GnuPG Pinentry server implementation for Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/EasyPG"
# taken from lisp/net/pinentry.el in GNU Emacs repo (commit bc511a64f6da)
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="app-crypt/pinentry[emacs]"

PATCHES=( "${FILESDIR}"/${PN}-emacs-29.patch )
SITEFILE="50${PN}-gentoo.el"
