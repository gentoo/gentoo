# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Split Strings Using Shell-Like Syntax"
HOMEPAGE="https://github.com/10sr/shell-split-string-el/"
SRC_URI="https://github.com/10sr/${PN}-el/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-el-${PV}

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake emacs=${EMACS} test
}
