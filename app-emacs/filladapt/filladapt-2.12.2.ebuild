# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp readme.gentoo-r1

DESCRIPTION="Filladapt enhances the behavior of Emacs' fill functions"
HOMEPAGE="http://www.wonderworks.com/
	https://elpa.gnu.org/packages/filladapt.html"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Filladapt is not enabled as a site default. Add the following
	lines to your ~/.emacs file to enable adaptive fill by default:
	\n\t(require 'filladapt)
	\n\t(setq-default filladapt-mode t)"
