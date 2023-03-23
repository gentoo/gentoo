# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Reformat OCaml's dune files automatically"
HOMEPAGE="https://github.com/purcell/emacs-dune-format/"
SRC_URI="https://github.com/purcell/emacs-${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-emacs/reformatter"
RDEPEND="
	${BDEPEND}
	dev-ml/dune
"

DOCS=( README.md )
ELISP_REMOVE="Makefile"  # Makefile downloads pkgs from net
SITEFILE="50${PN}-gentoo.el"
