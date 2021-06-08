# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=24

inherit elisp

DESCRIPTION="Use the Emacsclient as the \$EDITOR of child processes"
HOMEPAGE="https://magit.vc/manual/with-editor"
SRC_URI="https://github.com/magit/with-editor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="*.texi"
DOCS="README.md with-editor.org"

DEPEND=""
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} sys-apps/texinfo"
