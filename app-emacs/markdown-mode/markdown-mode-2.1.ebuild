# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Major mode for editing Markdown-formatted text files"
HOMEPAGE="https://jblevins.org/projects/markdown-mode/"
# Cannot use this url because its hash differ about every five minutes
# SRC_URI="http://jblevins.org/git/${PN}.git/snapshot/${P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="|| ( dev-python/markdown2 dev-python/markdown )"

SITEFILE="50${PN}-gentoo.el"
ELISP_PATCHES="${P}-text-auto-mode.patch"
