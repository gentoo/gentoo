# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Filladapt enhances the behavior of Emacs' fill functions"
HOMEPAGE="http://www.wonderworks.com/"
SRC_URI="mirror://gentoo/${P}.el.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Filladapt is not enabled as a site default. Add the following
	lines to your ~/.emacs file to enable adaptive fill by default:
	\n\t(require 'filladapt)
	\n\t(setq-default filladapt-mode t)"
