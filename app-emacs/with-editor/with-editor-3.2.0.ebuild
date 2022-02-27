# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=24

inherit elisp

DESCRIPTION="Use the Emacsclient as the \$EDITOR of child processes"
HOMEPAGE="https://magit.vc/manual/with-editor"
SRC_URI="https://github.com/magit/with-editor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="../docs/*.texi"
DOCS="../README.md ../docs/with-editor.org"

BDEPEND="sys-apps/texinfo"
