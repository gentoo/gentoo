# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Provides a modifier-free editing experience"
HOMEPAGE="https://github.com/susam/devil"
SRC_URI="https://github.com/susam/devil/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( MANUAL.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	elisp-test-ert . -l ${PN}-tests.el
}
