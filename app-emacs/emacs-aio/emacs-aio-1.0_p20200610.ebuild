# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=da93523e235529fa97d6f251319d9e1d6fc24a41
NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Async and await functions for Emacs Lisp"
HOMEPAGE="https://github.com/skeeto/emacs-aio/"
SRC_URI="https://github.com/skeeto/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_compile() {
	emake EMACS=${EMACS} compile
}

src_test() {
	emake EMACS=${EMACS} check
}
