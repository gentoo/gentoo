# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Split customizations into different files"
HOMEPAGE="https://www.emacswiki.org/emacs/InitSplit"
# taken from https://github.com/dabrahams/${PN}
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Initsplit is not enabled as a site default. Add the following
	line to your ~/.emacs file to enable configuration file splitting:
	\n\t(load \"initsplit\")
	\n\nIf you want configuration files byte-compiled, also add this line:
	\n\t(add-hook 'after-save-hook 'initsplit-byte-compile-files t)"
