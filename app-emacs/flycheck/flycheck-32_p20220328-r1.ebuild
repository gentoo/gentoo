# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Modern on-the-fly syntax checking extension for GNU Emacs"
HOMEPAGE="https://www.flycheck.org/
	https://github.com/flycheck/flycheck/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	if [[ ${PV} == *_p20220328 ]] ; then
		COMMIT=3b5b4248074f016922c2674789d4a242528cf4c7
		SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}-${COMMIT}
	else
		SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
	fi
	KEYWORDS="~alpha amd64 ~arm arm64 ~ppc64 ~riscv ~x64-macos"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test" # test requires cask and ert-runner which are not packaged yet

RDEPEND=">=app-emacs/dash-2.12.1
	>=app-emacs/pkg-info-0.4"

SITEFILE="50${PN}-gentoo-r1.el"
DOCS=( README.md )
ELISP_REMOVE="flycheck-buttercup.el flycheck-ert.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
