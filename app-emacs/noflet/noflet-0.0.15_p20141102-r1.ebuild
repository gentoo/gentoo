# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=7ae84dc3257637af7334101456dafe1759c6b68a

inherit elisp

DESCRIPTION="Dynamic, local advice for Emacs-Lisp code"
HOMEPAGE="https://github.com/nicferrier/emacs-noflet/"
SRC_URI="https://github.com/nicferrier/emacs-${PN}/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${PN}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/dash"
BDEPEND="${RDEPEND}"

DOCS=( README.creole )
PATCHES=( "${FILESDIR}"/${PN}-fix-requires.patch )

ELISP_REMOVE="let-while-tests.el"
SITEFILE="50${PN}-gentoo.el"
