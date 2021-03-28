# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="Filladapt enhances the behavior of Emacs' fill functions"
HOMEPAGE="http://www.wonderworks.com/"
SRC_URI="mirror://gentoo/${P}.el.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=("${FILESDIR}"/${P}-backquote.patch)
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Filladapt is not enabled as a site default. Add the following
	lines to your ~/.emacs file to enable adaptive fill by default:
	\n\t(require 'filladapt)
	\n\t(setq-default filladapt-mode t)"
