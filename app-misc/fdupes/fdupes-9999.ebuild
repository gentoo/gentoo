# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic git-r3 toolchain-funcs

MY_P="${PN}-${PV/_pre/-PR}"

DESCRIPTION="Identify/delete duplicate files residing within specified directories"
HOMEPAGE="https://github.com/adrianlopezroche/fdupes https://code.google.com/p/fdupes/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adrianlopezroche/fdupes.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch

	append-lfs-flags
	tc-export CC
}

src_install() {
	dobin fdupes
	doman fdupes.1
	dodoc CHANGES CONTRIBUTORS README TODO
}
