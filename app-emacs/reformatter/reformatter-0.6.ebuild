# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Define commands which run reformatters on the Emacs buffers"
HOMEPAGE="https://github.com/purcell/emacs-reformatter/"
SRC_URI="https://github.com/purcell/emacs-${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"  # Tests need "shfmt"

DOCS=( README.md )
ELISP_REMOVE="Makefile ${PN}-tests.el"  # Makefile downloads pkgs from net
SITEFILE="50${PN}-gentoo.el"
