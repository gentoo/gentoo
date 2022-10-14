# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="Emacs TRAMP integration for docker containers"
HOMEPAGE="https://github.com/emacs-pe/docker-tramp.el/"
SRC_URI="https://github.com/emacs-pe/${PN}.el/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
ELISP_REMOVE="Makefile"  # Does not define any tests.
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
