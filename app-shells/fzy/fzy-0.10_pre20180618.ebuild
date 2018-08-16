# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit savedconfig toolchain-funcs

EGIT_COMMIT="2697c02618d908e5bdcae93ab4815b04c49bd25e"

DESCRIPTION="Fuzzy text selector (interactive grep) for console"
HOMEPAGE="https://github.com/jhawthorn/fzy"
SRC_URI="https://github.com/jhawthorn/fzy/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

PATCHES=(
	"${FILESDIR}"/fzy-0.9-cflags.patch
	"${FILESDIR}"/fzy-add-utf-8-support.patch
)

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	restore_config config.h
	tc-export CC
}

src_install() {
	local DOCS=( ALGORITHM.md CHANGELOG.md README.md )
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	exeinto /usr/share/fzy
	doexe contrib/fzy-tmux
	doexe contrib/fzy-dvtm
	einstalldocs
	save_config config.h
}
