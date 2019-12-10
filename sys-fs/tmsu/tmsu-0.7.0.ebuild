# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build

EGO_PN="github.com/oniony/TMSU/"
DESCRIPTION="Files tagger and virtual tag-based filesystem"
HOMEPAGE="https://github.com/oniony/TMSU/wiki"
SRC_URI="https://github.com/oniony/TMSU/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test zsh-completion"
RESTRICT+=" !test? ( test )"

RDEPEND="
	zsh-completion? ( app-shells/zsh )
"
DEPEND="
	dev-go/go-sqlite3
	dev-lang/go
	dev-libs/go-fuse
"

src_unpack() {
	default
	mv TMSU-${PV} ${P} || die "Failed to move sorce directory."
}

src_install() {
	dobin misc/bin/*
	doman misc/man/tmsu.*
	newbin TMSU tmsu

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins misc/zsh/_tmsu
	fi
}
