# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
NEED_EMACS=24

inherit elisp

DESCRIPTION="Use the Emacsclient as the \$EDITOR of child processes"
HOMEPAGE="http://magit.vc/manual/with-editor"
SRC_URI="https://github.com/magit/with-editor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="*.texi"
DOCS="README.md with-editor.org"

DEPEND=">=app-emacs/dash-2.13.0"
# Versions of magit before 2.5.0 bundled with-editor
RDEPEND="!!<app-emacs/magit-2.5.0 ${DEPEND}"
