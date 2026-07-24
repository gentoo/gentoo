# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="https://magit.vc/
	https://github.com/magit/magit/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-31.0
	>=app-emacs/cond-let-1.1
	>=app-emacs/llama-1.0
	>=app-emacs/transient-0.13
	>=app-emacs/with-editor-3.5
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"
RDEPEND+="
	>=dev-vcs/git-2.44.2
"

DOCS=( ../README.md ../docs/{AUTHORS.md,magit{,-section}.org} )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	echo "" > ../default.mk || die
	emake magit-version.el PKG="${PN}" VERSION="${PV}"
}
