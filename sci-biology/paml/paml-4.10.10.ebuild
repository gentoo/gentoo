# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Phylogenetic Analysis by Maximum Likelihood"
HOMEPAGE="https://github.com/abacus-gene/paml/wiki"
SRC_URI="https://github.com/abacus-gene/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	emake -C src CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin src/{baseml,basemlg,codeml,evolver,pamp,mcmctree,infinitesites,yn00,chi2}

	dodoc -r README.md doc/.

	insinto /usr/share/${PN}/control
	doins examples/*.ctl

	insinto /usr/share/${PN}/dat
	doins -r examples/stewart* examples/*.dat dat/.

	insinto /usr/share/${PN}
	doins -r examples
}
