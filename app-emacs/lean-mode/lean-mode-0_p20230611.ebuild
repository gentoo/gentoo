# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs mode for the Lean 3 theorem prover"
HOMEPAGE="https://github.com/leanprover/lean-mode/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/leanprover/${PN}.git"
else
	[[ ${PV} == *_p20230611 ]] && COMMIT=99d6a34dc5b12f6e996e9217fa9f6fe4a6af037a
	SRC_URI="https://github.com/leanprover/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"

BDEPEND="
	>=app-emacs/dash-2.18.1
	>=app-emacs/f-0.19.0
	>=app-emacs/flycheck-32
	>=app-emacs/s-1.10.0
"
RDEPEND="
	${BDEPEND}
	sci-mathematics/lean:0/3
"

DOCS=( README.md )
ELISP_REMOVE="company-lean.el helm-lean.el"
SITEFILE="50${PN}-gentoo.el"
