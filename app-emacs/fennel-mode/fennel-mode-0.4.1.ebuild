# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs support for the Fennel programming language"
HOMEPAGE="https://gitlab.com/technomancy/fennel-mode/"
SRC_URI="https://gitlab.com/technomancy/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/fennel"

DOCS=( Readme.md changelog.md )
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	insinto "${SITEETC}"
	doins syntax.fnl
}
