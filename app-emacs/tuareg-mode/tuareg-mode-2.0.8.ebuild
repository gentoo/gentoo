# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="An Objective Caml/Camllight mode for Emacs"
HOMEPAGE="http://forge.ocamlcore.org/projects/tuareg/"
SRC_URI="https://github.com/ocaml/tuareg/releases/download/${PV}/tuareg-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

S="${WORKDIR}/tuareg-${PV}"
ELISP_REMOVE="tuareg-pkg.el tuareg-site-file.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
