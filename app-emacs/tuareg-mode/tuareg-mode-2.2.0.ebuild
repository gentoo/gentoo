# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="An Objective Caml/Camllight mode for Emacs"
HOMEPAGE="http://forge.ocamlcore.org/projects/tuareg/"
SRC_URI="https://github.com/ocaml/tuareg/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ GPL-3+ ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

S="${WORKDIR}/tuareg-${PV}"
ELISP_REMOVE="dot-emacs.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md CHANGES.md"
