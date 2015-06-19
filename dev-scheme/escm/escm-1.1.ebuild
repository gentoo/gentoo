# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/escm/escm-1.1.ebuild,v 1.9 2014/11/15 13:53:37 hattya Exp $

EAPI="5"

inherit autotools toolchain-funcs

DESCRIPTION="escm - Embedded Scheme Processor"
HOMEPAGE="http://practical-scheme.net/vault/escm.html"
SRC_URI="http://practical-scheme.net/vault/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="|| (
		dev-scheme/gauche
		dev-scheme/guile
	)"
S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i -e "6s/scm, snow/scm gosh, gosh/" configure.in
	eautoconf
	tc-export CC
}

src_install() {
	dobin escm
	doman escm.1
	dodoc ChangeLog escm.html
}
