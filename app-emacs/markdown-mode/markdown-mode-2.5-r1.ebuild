# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp optfeature

DESCRIPTION="Major mode for editing Markdown-formatted text files"
HOMEPAGE="https://jblevins.org/projects/markdown-mode/"
SRC_URI="https://github.com/jrblevin/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	|| (
		dev-python/markdown2
		dev-python/markdown
		virtual/pandoc
	)
"
BDEPEND="
	test? (
		virtual/pandoc
		|| (
			app-text/aspell[l10n_en]
			app-text/hunspell[l10n_en]
		)
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5-markdown-command.patch
	"${FILESDIR}"/${PN}-2.5-test.patch
)

DOCS=( CHANGES.md CONTRIBUTING.md README.md )
SITEFILE="50${PN}-gentoo.el"

pkg_postinst() {
	elisp_pkg_postinst

	optfeature "editing Markdown source code blocks" app-emacs/edit-indirect
}
