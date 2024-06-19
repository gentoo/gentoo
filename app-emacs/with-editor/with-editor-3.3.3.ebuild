# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Use the Emacsclient as the \$EDITOR of child processes"
HOMEPAGE="https://magit.vc/manual/with-editor/
	https://github.com/magit/with-editor/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}.git"
else
	SRC_URI="https://github.com/magit/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
fi

S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-29.1.4.1
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( ../README.org ../docs/${PN}.org )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"
