# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/rust-zshcomp/rust-zshcomp-1_beta20150411.ebuild,v 1.1 2015/04/11 21:47:31 jauhien Exp $

EAPI=5

DESCRIPTION="Rust zsh completions"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="http://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz"

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
