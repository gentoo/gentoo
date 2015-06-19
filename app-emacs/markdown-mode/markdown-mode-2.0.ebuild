# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/markdown-mode/markdown-mode-2.0.ebuild,v 1.2 2014/04/07 22:42:01 bicatali Exp $

EAPI=5

inherit elisp

DESCRIPTION="Major mode for editing Markdown-formatted text files"
HOMEPAGE="http://jblevins.org/projects/markdown-mode/"
# Cannot use this url because its hash differ about every five minutes
# SRC_URI="http://jblevins.org/git/${PN}.git/snapshot/${P}.tar.gz"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="|| ( dev-python/markdown2 dev-python/markdown )"

SITEFILE="50${PN}-gentoo.el"
