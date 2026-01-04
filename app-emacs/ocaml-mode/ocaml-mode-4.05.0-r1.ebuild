# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/-mode/}"

inherit elisp

DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="https://ocaml.org/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ocaml/ocaml"
else
	SRC_URI="https://github.com/ocaml/ocaml/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}/emacs"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( README README.itz )
SITEFILE="50${PN}-gentoo-3.12.1.el"
