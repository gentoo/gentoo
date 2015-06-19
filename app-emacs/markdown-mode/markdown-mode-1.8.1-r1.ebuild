# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/markdown-mode/markdown-mode-1.8.1-r1.ebuild,v 1.2 2014/03/01 10:04:06 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="Major mode for editing Markdown-formatted text files"
HOMEPAGE="http://jblevins.org/projects/markdown-mode/"
# Cannot use this url because its hash differ about every five minutes
# SRC_URI="http://jblevins.org/git/markdown-mode.git/snapshot/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/xz-utils"
RDEPEND="|| ( dev-python/markdown2 dev-python/markdown )"

SITEFILE="50${PN}-gentoo.el"
