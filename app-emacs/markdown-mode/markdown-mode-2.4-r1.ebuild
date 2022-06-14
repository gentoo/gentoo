# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Major mode for editing Markdown-formatted text files"
HOMEPAGE="https://jblevins.org/projects/markdown-mode/"
SRC_URI="https://github.com/jrblevin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="|| (
		dev-python/markdown2
		dev-python/markdown
		virtual/pandoc
	)"
BDEPEND="test? ( virtual/pandoc )"

PATCHES=( "${FILESDIR}"/${PN}-2.4-markdown-command.patch )
SITEFILE="50${PN}-gentoo.el"
DOCS="CHANGES.md CONTRIBUTING.md README.md"
