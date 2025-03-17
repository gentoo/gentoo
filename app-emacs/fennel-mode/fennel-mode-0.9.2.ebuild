# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs support for the Fennel programming language"
HOMEPAGE="https://git.sr.ht/~technomancy/fennel-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.sr.ht/~technomancy/${PN}"
else
	SRC_URI="https://git.sr.ht/~technomancy/${PN}/archive/${PV}.tar.gz
		-> ${P}.srht.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

ELISP_REMOVE="
	Makefile
"

DOCS=( README.md changelog.md )
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	insinto "${SITEETC}"
	doins syntax.fnl
}
