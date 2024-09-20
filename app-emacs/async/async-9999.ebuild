# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REAL_PN="emacs-async"
REAL_P="${REAL_PN}-${PV}"

inherit elisp

DESCRIPTION="Simple library for asynchronous processing in Emacs"
HOMEPAGE="https://github.com/jwiegley/emacs-async/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/jwiegley/${REAL_PN}.git"
else
	SRC_URI="https://github.com/jwiegley/${REAL_PN}/archive/v${PV}.tar.gz
		-> ${REAL_P}.tar.gz"
	S="${WORKDIR}/${REAL_PN}-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
