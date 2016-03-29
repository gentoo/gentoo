# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
NEED_EMACS=24

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="http://magit.vc/"
SRC_URI="https://github.com/magit/magit/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${P}/lisp"
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="../Documentation/*.texi"
DOCS="../README.md ../Documentation/AUTHORS.md ../Documentation/${PV}.txt"

DEPEND=">=app-emacs/dash-2.12.1 >=app-emacs/with-editor-2.5.0"
RDEPEND="${DEPEND} >=dev-vcs/git-1.9.4"
