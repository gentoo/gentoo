# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Use Emacs as a paginator"
HOMEPAGE="https://eless.scripter.co/ https://github.com/kaushalmodi/eless/"
SRC_URI="https://github.com/kaushalmodi/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"  # Tests have to be run manually

RDEPEND="
	>=app-editors/emacs-25.3:*
	app-shells/bash
	dev-lang/perl
"

src_compile() {
	:  # Nothing to compile
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.org README.org
	doinfo docs/${PN}.info
}
