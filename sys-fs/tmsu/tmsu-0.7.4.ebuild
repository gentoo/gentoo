# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build

EGO_PN="github.com/oniony/TMSU/"
DESCRIPTION="Files tagger and virtual tag-based filesystem"
HOMEPAGE="https://github.com/oniony/TMSU/wiki"
SRC_URI="https://github.com/oniony/TMSU/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-fs/fuse:0"
DEPEND="
	dev-go/go-sqlite3
	dev-lang/go
	dev-libs/go-fuse
	test? ( ${RDEPEND} )
"

src_unpack() {
	default
	mv TMSU-${PV} ${P} || die "Failed to move sorce directory."
}

src_install() {
	dobin misc/bin/*
	doman misc/man/tmsu.*
	newbin TMSU tmsu

	insinto /usr/share/zsh/site-functions
	doins misc/zsh/_tmsu
}

src_test() {
	cd tests || die
	./runall || die
}
