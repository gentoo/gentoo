# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="24.3"

inherit elisp

DESCRIPTION="Modern on-the-fly syntax checking extension for GNU Emacs"
HOMEPAGE="https://www.flycheck.org/"
COMMIT="3b5b4248074f016922c2674789d4a242528cf4c7"
SRC_URI="https://github.com/flycheck/flycheck/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
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
