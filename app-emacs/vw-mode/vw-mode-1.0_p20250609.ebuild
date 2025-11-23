# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for editing VW Grammars for GNU Emacs"
HOMEPAGE="https://git.sr.ht/~jemarch/vw-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.sr.ht/~jemarch/${PN}"
else
	if [[ "${PV}" == *_p20250609 ]] ; then
		COMMIT="d9c537065074f5752458f481a09faa93b244ce05"
	fi

	SRC_URI="https://git.sr.ht/~jemarch/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.srht.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md abc.vw )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
