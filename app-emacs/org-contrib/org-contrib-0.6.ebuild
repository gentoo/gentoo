# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Contributed packages to Org"
HOMEPAGE="https://orgmode.org/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.sr.ht/~bzg/${PN}"
else
	SRC_URI="https://git.sr.ht/~bzg/${PN}/archive/release_${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-release_${PV}/lisp"

	KEYWORDS="amd64 ~arm64 ~ppc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/org-mode-9.5
"

DOCS=( ../README.org )
SITEFILE="50${PN}-gentoo.el"
