# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/wgrep/wgrep-2.1.10.ebuild,v 1.1 2015/02/24 17:29:04 ulm Exp $

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Writable grep buffer and apply the changes to files"
HOMEPAGE="https://github.com/mhayashi1120/Emacs-wgrep"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="See commentary in ${SITELISP}/${PN}/wgrep.el for documentation.
	\n\nTo activate wgrep, add the following line to your ~/.emacs file:
	\n\t(require 'wgrep)"
