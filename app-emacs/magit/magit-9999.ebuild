# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="https://magit.vc/
	https://github.com/magit/magit/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/magit.git"
else
	SRC_URI="https://github.com/magit/magit/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
fi

S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

DOCS=( ../README.md ../docs/AUTHORS.md ../docs/RelNotes )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=app-emacs/compat-29.1.4.5
	>=app-emacs/dash-2.19.1
	>=app-emacs/transient-0.6.0
	>=app-emacs/with-editor-3.3.2
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"
RDEPEND+="
	>=dev-vcs/git-2.0.0
"

src_prepare() {
	default

	rm magit-libgit.el || die
	echo "(setq magit-version \"${PV}\")" > ./magit-version.el || die
}
