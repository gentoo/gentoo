# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Relative loads for Emacs Lisp files"
HOMEPAGE="https://github.com/rocky/emacs-load-relative/"
SRC_URI="https://github.com/rocky/emacs-${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( ChangeLog README.md )
SITEFILE="50${PN}-gentoo.el"
