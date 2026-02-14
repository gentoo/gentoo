# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == *p20250911 ]] && COMMIT="f0cb55f2177f6fc978d98d018910fe5b1890fe0c"

inherit elisp

DESCRIPTION="An Objective Caml/Camllight mode for Emacs"
HOMEPAGE="http://forge.ocamlcore.org/projects/tuareg/
	https://github.com/ocaml/tuareg/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ocaml/tuareg"
else
	SRC_URI="https://github.com/ocaml/tuareg/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/tuareg-${COMMIT}"

	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2+ GPL-3+ ISC"
SLOT="0"

ELISP_REMOVE="
	Makefile
	dot-emacs.el
	tuareg-tests.el
"
SITEFILE="50${PN}-gentoo.el"
DOCS=( README.md CHANGES.md )
