# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

COMMIT="0079964a1dde954ccb2ce8a28613d8020c549a36"
DESCRIPTION="GnuPG Pinentry server implementation for Emacs"
HOMEPAGE="https://github.com/ueno/pinentry-el
	https://www.emacswiki.org/emacs/EasyPG"
SRC_URI="https://github.com/ueno/${PN}-el/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-el-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="app-crypt/pinentry[emacs]"

SITEFILE="50${PN}-gentoo.el"
