# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Advanced highlighting of matching parentheses"
HOMEPAGE="https://web.archive.org/web/20211016050703/https://www.gnuvola.org/software/j/mic-paren/
	https://www.emacswiki.org/emacs/MicParen"
# taken from http://www.gnuvola.org/software/j/mic-paren/mic-paren.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-quoting.patch
	"${FILESDIR}"/${P}-cl-lib.patch
)

SITEFILE="50${PN}-gentoo.el"
