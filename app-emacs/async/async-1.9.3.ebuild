# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_P="emacs-async-${PV}"
DESCRIPTION="Simple library for asynchronous processing in Emacs"
HOMEPAGE="https://github.com/jwiegley/emacs-async"
SRC_URI="https://github.com/jwiegley/emacs-async/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
