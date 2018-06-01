# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Major mode for editing Markdown-formatted text files"
HOMEPAGE="https://jblevins.org/projects/markdown-mode/"
SRC_URI="https://stable.melpa.org/packages/${P}.el"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="|| ( dev-python/markdown2 dev-python/markdown )"

S="${WORKDIR}"

SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	cp "${DISTDIR}"/${P}.el ${PN}.el || die
}
