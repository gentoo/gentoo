# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Rust zsh completions"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="https://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-shells/zsh"
RDEPEND="${DEPEND}"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	insinto /usr/share/zsh/site-functions
	doins _rust
}
